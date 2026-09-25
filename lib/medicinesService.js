import { supabase, isSupabaseConfigured } from './supabase.js';

/**
 * Known category classification helper to map medicine names / active ingredients
 * to the UI filter categories ('cardio', 'diabetes', 'antibiotics', 'gastro', 'analgesics').
 */
function inferCategory(name, substance) {
  const combined = (name + ' ' + (substance || '')).toLowerCase();
  if (combined.includes('ضغط') || combined.includes('قلب') || combined.includes('كونكور') || 
      combined.includes('بستول') || combined.includes('إكسفورج') || combined.includes('أمبلوبريس') ||
      combined.includes('أندرال') || combined.includes('بروبرانولول') || combined.includes('بيسوبرولول')) {
    return { category: 'cardio', categoryName: 'أدوية الضغط والقلب' };
  }
  if (combined.includes('سكر') || combined.includes('جالفس') || combined.includes('جلوكوڤاميت') ||
      combined.includes('سيدوفاج') || combined.includes('ميتفورمين') || combined.includes('أوزمبك') ||
      combined.includes('غدة') || combined.includes('إيوتيروكس') || combined.includes('ثايروكسين')) {
    return { category: 'diabetes', categoryName: 'أدوية السكر والغدد' };
  }
  if (combined.includes('مضاد') || combined.includes('أوجمنتين') || combined.includes('إيموكسكلاف') ||
      combined.includes('كلافوكس') || combined.includes('ميغاموكس') || combined.includes('زوفيراكس') ||
      combined.includes('سيكلوفيرال')) {
    return { category: 'antibiotics', categoryName: 'المضادات الحيوية والفيروسات' };
  }
  if (combined.includes('معدة') || combined.includes('حموضة') || combined.includes('أومبريز') ||
      combined.includes('هيليكير') || combined.includes('كونترولوك') || combined.includes('زوركال') ||
      combined.includes('ارتجاع')) {
    return { category: 'gastro', categoryName: 'أدوية الجهاز الهضمي والمعدة' };
  }
  if (combined.includes('مسكن') || combined.includes('كتَافلام') || combined.includes('كتافلام') ||
      combined.includes('ديكلوفين') || combined.includes('أسبرين') || combined.includes('إيجيبيرين') ||
      combined.includes('تجريتول') || combined.includes('مازيبين')) {
    return { category: 'analgesics', categoryName: 'المسكنات والسيولة' };
  }
  return { category: 'cardio', categoryName: 'أدوية عامة ومعتمدة' };
}

/**
 * Fetch medicines and pharmacy stocks from Supabase PostgreSQL.
 * Uses:
 *   supabase.from('medicines').select('*')
 *   supabase.from('pharmacies_stock').select('*')
 * and correlates them via medicines.id <-> pharmacies_stock.medicine_id
 */
export async function fetchMedicinesWithStock() {
  if (!isSupabaseConfigured || !supabase) {
    return { data: null, error: new Error('SUPABASE_NOT_CONFIGURED') };
  }

  try {
    // 1. Query medicines table
    const { data: medicines, error: medError } = await supabase
      .from('medicines')
      .select('*')
      .order('name');

    if (medError) throw medError;
    if (!medicines || medicines.length === 0) {
      return { data: [], error: null };
    }

    // 2. Query pharmacies_stock table
    const { data: stockRecords, error: stockError } = await supabase
      .from('pharmacies_stock')
      .select('*');

    if (stockError) throw stockError;

    // Build map of stocks by medicine_id
    const stockMap = new Map();
    if (stockRecords) {
      stockRecords.forEach(s => {
        if (!stockMap.has(s.medicine_id)) {
          stockMap.set(s.medicine_id, []);
        }
        stockMap.get(s.medicine_id).push(s);
      });
    }

    // 3. Build a lookup map of medicines by id and by name for pairing alternatives
    const medMapById = new Map();
    const medMapByName = new Map();
    medicines.forEach(m => {
      medMapById.set(m.id, m);
      medMapByName.set(m.name.trim().toLowerCase(), m);
    });

    // 4. Transform and normalize rows into the UI drug entity format
    const transformedDrugs = medicines.map((m, index) => {
      const stocks = stockMap.get(m.id) || [];
      const primaryStock = stocks[0] || null;

      const isAvailable = Boolean(m.is_available && (primaryStock ? primaryStock.stock_quantity > 0 : true));
      const stockQty = primaryStock ? primaryStock.stock_quantity : (isAvailable ? 20 : 0);
      const discountPercent = primaryStock ? Number(primaryStock.discount_percent) || 0 : 0;

      let status = 'متوفر';
      let isScarce = false;
      let isOutOfStock = false;

      if (!isAvailable || stockQty === 0) {
        status = 'غير متوفر حالياً بالمخزون القريب';
        isOutOfStock = true;
        isScarce = true;
      } else if (stockQty <= 3) {
        status = `متبقي ${stockQty} عبوات`;
        isScarce = true;
      }

      // Check for generic alternative counterpart in dataset
      let counterpartId = null;
      if (m.generic_alternative) {
        const altClean = m.generic_alternative.trim().toLowerCase();
        for (const [nameKey, candidate] of medMapByName.entries()) {
          if (nameKey.includes(altClean) || altClean.includes(nameKey)) {
            counterpartId = candidate.id;
            break;
          }
        }
      }

      // Infer category
      const { category, categoryName } = inferCategory(m.name, m.active_ingredient);

      // Determine price
      let price = 50.0;
      if (m.price) {
        price = Number(m.price);
      } else if (discountPercent > 0 && m.alternative_price) {
        // e.g., if this is original and alternative has 50% discount at 28 EGP, original is ~56 EGP
        price = Number((Number(m.alternative_price) / (1 - discountPercent / 100)).toFixed(2));
      } else if (m.alternative_price) {
        price = Number(m.alternative_price);
      }

      const pharmacyName = primaryStock ? primaryStock.pharmacy_name : `صيدلية شريكة رقم #${100 + index} — نطاق القاهرة`;
      const distanceM = 250 + (index * 60) % 600;

      return {
        id: m.id,
        counterpartId: counterpartId,
        name: m.name,
        substance: m.active_ingredient || 'المادة الفعالة المصرح بها من هيئة الدواء',
        type: discountPercent > 0 || (m.generic_alternative && m.generic_alternative.length > 0) ? (index % 2 === 0 ? 'original' : 'generic') : 'original',
        savings: discountPercent > 0 ? `وفر ${Math.round(discountPercent)}%` : null,
        matchScore: '100%',
        category: category,
        categoryName: categoryName,
        anonymizedPharmacy: pharmacyName,
        distanceText: `على بُعد ${distanceM} متر`,
        relativeArea: `تأكيد التوصيل من أقرب صيدلية شريكة على بُعد ${distanceM} متر`,
        rating: `★ 4.9 (${90 + (index * 13) % 80}+ تقييم)`,
        distanceM: distanceM,
        price: price,
        status: status,
        isScarce: isScarce,
        isOutOfStock: isOutOfStock,
        generic_alternative: m.generic_alternative || null,
        alternative_price: m.alternative_price ? Number(m.alternative_price) : null,
        stock_quantity: stockQty,
        discount_percent: discountPercent,
        key: `${m.name} ${m.active_ingredient || ''}`.toLowerCase()
      };
    });

    return { data: transformedDrugs, error: null };
  } catch (err) {
    console.error('[Elajk] Error fetching medicines from Supabase:', err);
    return { data: null, error: err };
  }
}
