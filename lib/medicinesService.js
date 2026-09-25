import { supabase, isSupabaseConfigured } from './supabase.js';

/**
 * Built-in fallback metadata map keyed by Supabase UUID to guarantee 100% backward
 * and forward compatibility across the application's runtime drug catalog.
 */
const UUID_METADATA = {
  '54bc1ec8-ab9b-4d7b-ad76-4a51f571b327': {
    slug: 'concor-5',
    counterpartSlug: 'bistol-5',
    type: 'original',
    category: 'cardio',
    categoryName: 'أدوية الضغط والقلب',
    price: 56.50,
    distanceM: 350,
    rating: '★ 4.9 (140+ تقييم)',
    key: 'كونكور بيسوبرولول ضغط قلب'
  },
  '1c9f8fc7-59a4-4e6b-a100-d3949da03435': {
    slug: 'bistol-5',
    counterpartSlug: 'concor-5',
    type: 'generic',
    category: 'cardio',
    categoryName: 'أدوية الضغط والقلب',
    price: 28.00,
    distanceM: 500,
    rating: '★ 4.8 (95+ تقييم)',
    savings: 'وفر 50%',
    matchScore: '100%',
    key: 'كونكور بستول بيستول بيسوبرولول'
  },
  '24befff3-e700-4c2e-ada0-12de72bdddaa': {
    slug: 'exforge-5-160',
    counterpartSlug: 'amblopress-5-160',
    type: 'original',
    category: 'cardio',
    categoryName: 'أدوية الضغط والقلب',
    price: 165.00,
    distanceM: 400,
    rating: '★ 4.9 (110+ تقييم)',
    key: 'إكسفورج أملوديبين فالسارتان ضغط'
  },
  'ee868313-e900-4101-a491-c14089d762f6': {
    slug: 'amblopress-5-160',
    counterpartSlug: 'exforge-5-160',
    type: 'generic',
    category: 'cardio',
    categoryName: 'أدوية الضغط والقلب',
    price: 95.00,
    distanceM: 650,
    rating: '★ 4.8 (85+ تقييم)',
    savings: 'وفر 42%',
    matchScore: '100%',
    key: 'إكسفورج أمبلوبريس فالسارتان'
  },
  '680384ed-7604-4ebd-a07b-208d03f94f05': {
    slug: 'inderal-10',
    counterpartSlug: 'propranolol-10',
    type: 'original',
    category: 'cardio',
    categoryName: 'أدوية الضغط والقلب',
    price: 32.00,
    distanceM: 420,
    rating: '★ 4.9 (160+ تقييم)',
    key: 'أندرال انيدرال بروبرانولول ضربات القلب'
  },
  'e13de3e1-5a9e-48af-a533-c75cb19a1b4a': {
    slug: 'propranolol-10',
    counterpartSlug: 'inderal-10',
    type: 'generic',
    category: 'cardio',
    categoryName: 'أدوية الضغط والقلب',
    price: 17.50,
    distanceM: 620,
    rating: '★ 4.7 (75+ تقييم)',
    savings: 'وفر 45%',
    matchScore: '100%',
    key: 'أندرال بروبرانولول'
  },
  'f78196b3-dc0b-4bcd-ac43-6ae08c7d7f9d': {
    slug: 'galvus-met-50-1000',
    counterpartSlug: 'glucovamet-50-1000',
    type: 'original',
    category: 'diabetes',
    categoryName: 'السكر والغدد',
    price: 180.00,
    distanceM: 550,
    rating: '★ 4.9 (175+ تقييم)',
    key: 'جالفس ميت جالفز فيلداجليبتين ميتفورمين سكر'
  },
  '8bd808aa-010f-42dc-aeb1-5e7386e98069': {
    slug: 'glucovamet-50-1000',
    counterpartSlug: 'galvus-met-50-1000',
    type: 'generic',
    category: 'diabetes',
    categoryName: 'السكر والغدد',
    price: 110.00,
    distanceM: 700,
    rating: '★ 4.8 (90+ تقييم)',
    savings: 'وفر 39%',
    matchScore: '100%',
    key: 'جالفس جلوكوفاميت جلوكوڤاميت سكر'
  },
  'b432f36b-00d7-4e4d-a105-72a3955a24d5': {
    slug: 'cidophage-850',
    counterpartSlug: 'metformin-850',
    type: 'original',
    category: 'diabetes',
    categoryName: 'السكر والغدد',
    price: 24.00,
    distanceM: 300,
    rating: '★ 4.8 (130+ تقييم)',
    key: 'سيدوفاج ميتفورمين سكر تخسيس'
  },
  '16f19ea1-9f07-46be-ad02-fdc7e26962e7': {
    slug: 'metformin-850',
    counterpartSlug: 'cidophage-850',
    type: 'generic',
    category: 'diabetes',
    categoryName: 'السكر والغدد',
    price: 15.00,
    distanceM: 480,
    rating: '★ 4.7 (75+ تقييم)',
    savings: 'وفر 38%',
    matchScore: '100%',
    key: 'سيدوفاج ميتفورمين سكر'
  },
  '1a803011-17d9-4094-af65-7dd86309fe36': {
    slug: 'euthyrox-100',
    counterpartSlug: 'thyroxin-100',
    type: 'original',
    category: 'diabetes',
    categoryName: 'السكر والغدد',
    price: 90.00,
    distanceM: 650,
    rating: '★ 4.9 (240+ تقييم)',
    key: 'إيوتيروكس يوثيروكس ليفوثيروكسين غدة درقية'
  },
  '9401c434-624b-48bd-a218-a36c53bb672f': {
    slug: 'thyroxin-100',
    counterpartSlug: 'euthyrox-100',
    type: 'generic',
    category: 'diabetes',
    categoryName: 'السكر والغدد',
    price: 48.00,
    distanceM: 820,
    rating: '★ 4.8 (110+ تقييم)',
    savings: 'وفر 47%',
    matchScore: '100%',
    key: 'إيوتيروكس ثايروكسين ثيروكسين غدة'
  },
  'd93599fe-22ef-4e36-ae12-1b069f0bcc52': {
    slug: 'augmentin-1g',
    counterpartSlug: 'emoxclav-1g',
    type: 'original',
    category: 'antibiotics',
    categoryName: 'المضادات والفيروسات',
    price: 99.00,
    distanceM: 600,
    rating: '★ 4.9 (180+ تقييم)',
    key: 'أوجمنتين اوجمنتين أموكسيسيلين مضاد حيوي'
  },
  '9c19efb6-4f40-4e9f-a566-886be5c9ff7b': {
    slug: 'emoxclav-1g',
    counterpartSlug: 'augmentin-1g',
    type: 'generic',
    category: 'antibiotics',
    categoryName: 'المضادات والفيروسات',
    price: 62.00,
    distanceM: 750,
    rating: '★ 4.8 (115+ تقييم)',
    savings: 'وفر 37%',
    matchScore: '100%',
    key: 'أوجمنتين إيموكسكلاف ايموكسكلاف مضاد'
  },
  '06258f48-2f8d-4e2b-a905-0668c8aeb7d0': {
    slug: 'klavox-625',
    counterpartSlug: 'megamox-625',
    type: 'original',
    category: 'antibiotics',
    categoryName: 'المضادات والفيروسات',
    price: 75.00,
    distanceM: 800,
    rating: '★ 4.8 (95+ تقييم)',
    key: 'كلافوكس أموكسيسيلين مضاد'
  },
  'b0d417b6-bf5a-4710-af43-fbc33bc6dd55': {
    slug: 'megamox-625',
    counterpartSlug: 'klavox-625',
    type: 'generic',
    category: 'antibiotics',
    categoryName: 'المضادات والفيروسات',
    price: 48.00,
    distanceM: 950,
    rating: '★ 4.7 (70+ تقييم)',
    savings: 'وفر 36%',
    matchScore: '100%',
    key: 'كلافوكس ميغاموكس ميجاموكس'
  },
  '63001216-5170-4af8-aa47-b5d85bed16c7': {
    slug: 'zovirax-400',
    counterpartSlug: 'cycloviral-400',
    type: 'original',
    category: 'antibiotics',
    categoryName: 'المضادات والفيروسات',
    price: 120.00,
    distanceM: 490,
    rating: '★ 4.9 (185+ تقييم)',
    key: 'زوفيراكس اسيكلوفير فيروسات هربس'
  },
  '981e368b-2451-42e3-a70c-c74582e5484c': {
    slug: 'cycloviral-400',
    counterpartSlug: 'zovirax-400',
    type: 'generic',
    category: 'antibiotics',
    categoryName: 'المضادات والفيروسات',
    price: 65.00,
    distanceM: 680,
    rating: '★ 4.8 (80+ تقييم)',
    savings: 'وفر 46%',
    matchScore: '100%',
    key: 'زوفيراكس سيكلوفيرال اسيكلوفير'
  },
  '17965bd0-923e-4bf3-a1d6-fdfaa98f20c3': {
    slug: 'omeprez-20',
    counterpartSlug: 'helicure-20',
    type: 'original',
    category: 'gastro',
    categoryName: 'الجهاز الهضمي والأعصاب',
    price: 68.00,
    distanceM: 420,
    rating: '★ 4.9 (135+ تقييم)',
    key: 'أومبريز اومبريز أوميبرازول معدة حموضة'
  },
  'baaa546c-41da-43a4-a37d-98036a7821fe': {
    slug: 'helicure-20',
    counterpartSlug: 'omeprez-20',
    type: 'generic',
    category: 'gastro',
    categoryName: 'الجهاز الهضمي والأعصاب',
    price: 39.00,
    distanceM: 560,
    rating: '★ 4.8 (88+ تقييم)',
    savings: 'وفر 43%',
    matchScore: '100%',
    key: 'أومبريز هيليكير هيليكيور أوميبرازول معدة'
  },
  'a33db4ae-b9b0-4f92-aae7-11cbfa630160': {
    slug: 'controloc-40',
    counterpartSlug: 'zurcal-40',
    type: 'original',
    category: 'gastro',
    categoryName: 'الجهاز الهضمي والأعصاب',
    price: 140.00,
    distanceM: 380,
    rating: '★ 4.9 (210+ تقييم)',
    key: 'كونترولوك بانتوبرازول معدة ارتجاع حموضة'
  },
  'f13e23f5-0199-4d07-a3d2-9f1dc4bd8c7e': {
    slug: 'zurcal-40',
    counterpartSlug: 'controloc-40',
    type: 'generic',
    category: 'gastro',
    categoryName: 'الجهاز الهضمي والأعصاب',
    price: 78.00,
    distanceM: 520,
    rating: '★ 4.8 (95+ تقييم)',
    savings: 'وفر 44%',
    matchScore: '100%',
    key: 'كونترولوك زوركال بانتوبرازول معدة'
  },
  '62f0af73-fd7b-4aa7-a034-e3856a738fbf': {
    slug: 'tegretol-200',
    counterpartSlug: 'mazepine-200',
    type: 'original',
    category: 'gastro',
    categoryName: 'الجهاز الهضمي والأعصاب',
    price: 48.00,
    distanceM: 410,
    rating: '★ 4.9 (160+ تقييم)',
    key: 'تجريتول كاربامازيبين أعصاب تشنجات'
  },
  '2e47f85f-944a-43ce-a150-adeaacc34a1f': {
    slug: 'mazepine-200',
    counterpartSlug: 'tegretol-200',
    type: 'generic',
    category: 'gastro',
    categoryName: 'الجهاز الهضمي والأعصاب',
    price: 26.00,
    distanceM: 580,
    rating: '★ 4.7 (65+ تقييم)',
    savings: 'وفر 46%',
    matchScore: '100%',
    key: 'تجريتول مازيبين كاربامازيبين'
  },
  '70d8d985-c856-4fb3-a086-519c96e3cb9f': {
    slug: 'aspirin-protect-100',
    counterpartSlug: 'egypirin-100',
    type: 'original',
    category: 'analgesics',
    categoryName: 'المسكنات والربو',
    price: 36.00,
    distanceM: 450,
    rating: '★ 4.9 (210+ تقييم)',
    key: 'أسبرين اسبرين حماية القلب سيولة بروتكت'
  },
  '05ac016e-aa66-44a8-aa81-ee52a99d397f': {
    slug: 'egypirin-100',
    counterpartSlug: 'aspirin-protect-100',
    type: 'generic',
    category: 'analgesics',
    categoryName: 'المسكنات والربو',
    price: 18.00,
    distanceM: 600,
    rating: '★ 4.8 (95+ تقييم)',
    savings: 'وفر 50%',
    matchScore: '100%',
    key: 'أسبرين إيجيبيرين ايجيبيرين سيولة'
  },
  'ba6fb676-4535-4c0c-aeba-e92c88e61152': {
    slug: 'cataflam-50',
    counterpartSlug: 'diclofen-50',
    type: 'original',
    category: 'analgesics',
    categoryName: 'المسكنات والربو',
    price: 42.00,
    distanceM: 380,
    rating: '★ 4.9 (290+ تقييم)',
    key: 'كتافلام كتافلام كتَافلام ديكلوفيناك مسكن'
  },
  '5e2905c9-ff28-40b0-a279-a17cce5e3f66': {
    slug: 'diclofen-50',
    counterpartSlug: 'cataflam-50',
    type: 'generic',
    category: 'analgesics',
    categoryName: 'المسكنات والربو',
    price: 22.00,
    distanceM: 520,
    rating: '★ 4.8 (145+ تقييم)',
    savings: 'وفر 48%',
    matchScore: '100%',
    key: 'كتافلام ديكلوفين ديكلوفيناك مسكن'
  },
  '70a0e0d1-9fcc-4e0d-a9f0-cf4e16a49ab8': {
    slug: 'ventolin-inhaler',
    counterpartSlug: 'farcolin-inhaler',
    type: 'original',
    category: 'analgesics',
    categoryName: 'المسكنات والربو',
    price: 85.00,
    distanceM: 470,
    rating: '★ 4.9 (220+ تقييم)',
    key: 'فنتولين بخاخ سالبيوتامول حساسية صدر ربو'
  },
  'b91d6304-754c-4952-aefc-579f3d1a5042': {
    slug: 'farcolin-inhaler',
    counterpartSlug: 'ventolin-inhaler',
    type: 'generic',
    category: 'analgesics',
    categoryName: 'المسكنات والربو',
    price: 44.00,
    distanceM: 610,
    rating: '★ 4.8 (105+ تقييم)',
    savings: 'وفر 48%',
    matchScore: '100%',
    key: 'فنتولين فاركولين بخاخ سالبيوتامول'
  },
  '88655c08-6002-4559-abd9-18eb3ded832a': {
    slug: 'mucophylline-syrup',
    counterpartSlug: 'bronchofin-syrup',
    type: 'original',
    category: 'analgesics',
    categoryName: 'المسكنات والربو',
    price: 30.00,
    distanceM: 430,
    rating: '★ 4.8 (115+ تقييم)',
    key: 'ميوكوفيلين شراب كحة بلغم حساسية'
  },
  'cf4b12ba-75e1-4722-a969-b11da0aa1c08': {
    slug: 'bronchofin-syrup',
    counterpartSlug: 'mucophylline-syrup',
    type: 'generic',
    category: 'analgesics',
    categoryName: 'المسكنات والربو',
    price: 17.00,
    distanceM: 590,
    rating: '★ 4.7 (80+ تقييم)',
    savings: 'وفر 43%',
    matchScore: '100%',
    key: 'ميوكوفيلين برونكوفين برونكوفان شراب كحة'
  },
  'd7a55070-3db1-45f6-a2b4-28b24293f263': {
    slug: 'ozempic-1mg',
    counterpartSlug: null,
    type: 'original',
    category: 'diabetes',
    categoryName: 'السكر والغدد',
    price: 3800.00,
    distanceM: 5000,
    rating: '★ 5.0 (410+ تقييم)',
    key: 'أوزمبك اوزمبك سيماجلوتيد سكر تخسيس قلم'
  }
};

/**
 * Fetch medicines and related pharmacy stocks from Supabase PostgreSQL.
 * Queries:
 *   supabase.from('medicines').select('*')
 *   supabase.from('pharmacies_stock').select('*')
 * and correlates them via medicines.id <-> pharmacies_stock.medicine_id.
 */
export async function fetchMedicinesWithStock() {
  if (!isSupabaseConfigured || !supabase) {
    return { data: null, error: new Error('SUPABASE_NOT_CONFIGURED') };
  }

  try {
    // 1. Fetch all medicines
    const { data: medicines, error: medError } = await supabase
      .from('medicines')
      .select('*')
      .order('name');

    if (medError) throw medError;
    if (!medicines || medicines.length === 0) {
      return { data: [], error: null };
    }

    // 2. Fetch all pharmacy stock entries
    const { data: stockRecords, error: stockError } = await supabase
      .from('pharmacies_stock')
      .select('*');

    if (stockError) throw stockError;

    // Build map of stocks by medicine UUID
    const stockMap = new Map();
    if (stockRecords) {
      stockRecords.forEach(s => {
        if (!stockMap.has(s.medicine_id)) {
          stockMap.set(s.medicine_id, []);
        }
        stockMap.get(s.medicine_id).push(s);
      });
    }

    // 3. Build lookup maps for cross-referencing
    const medBySlug = new Map();
    const medByUuid = new Map();
    medicines.forEach(m => {
      const meta = UUID_METADATA[m.id] || {};
      const slug = m.slug || meta.slug || m.id;
      medBySlug.set(slug, m);
      medByUuid.set(m.id, m);
    });

    // 4. Transform into the exact UI runtime entity format
    const transformed = medicines.map((m, index) => {
      const meta = UUID_METADATA[m.id] || {};
      const stocks = stockMap.get(m.id) || [];
      const primaryStock = stocks[0] || null;

      // Primary ID is the slug (e.g. 'concor-5') for full runtime compatibility,
      // with db_id preserving the PostgreSQL UUID.
      const slugId = m.slug || meta.slug || m.id;
      const counterpartSlug = m.counterpart_slug || meta.counterpartSlug || null;

      const isAvailable = Boolean(m.is_available && (primaryStock ? primaryStock.stock_quantity > 0 : true));
      const stockQty = primaryStock ? primaryStock.stock_quantity : (isAvailable ? 20 : 0);
      const discountPercent = primaryStock ? Number(primaryStock.discount_percent) || 0 : (meta.discountPercent || 0);

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

      const type = m.type || meta.type || (m.generic_alternative ? 'original' : 'generic');
      const category = m.category || meta.category || 'cardio';
      const categoryName = m.category_name || meta.categoryName || 'أدوية عامة';
      const price = m.price != null ? Number(m.price) : (meta.price || 50.0);
      const distanceM = m.distance_m != null ? Number(m.distance_m) : (meta.distanceM || (300 + (index * 40) % 500));
      const rating = m.rating || meta.rating || `★ 4.8 (${80 + (index * 11) % 90}+ تقييم)`;
      const pharmacyName = primaryStock ? primaryStock.pharmacy_name : `صيدلية شريكة رقم #${100 + index} — نطاق القاهرة`;
      const searchKey = m.search_key || meta.key || `${m.name} ${m.active_ingredient || ''}`.toLowerCase();
      const savings = m.savings || meta.savings || (discountPercent > 0 ? `وفر ${Math.round(discountPercent)}%` : null);
      const matchScore = m.match_score || meta.matchScore || (type === 'generic' ? '100%' : null);

      return {
        id: slugId,
        db_id: m.id,
        counterpartId: counterpartSlug,
        name: m.name,
        substance: m.active_ingredient || 'المادة الفعالة المصرح بها من هيئة الدواء',
        type: type,
        savings: savings,
        matchScore: matchScore,
        category: category,
        categoryName: categoryName,
        anonymizedPharmacy: pharmacyName,
        distanceText: isOutOfStock && slugId === 'ozempic-1mg' ? 'غير متاح حالياً بالصيدليات المجاورة' : `على بُعد ${distanceM} متر`,
        relativeArea: isOutOfStock && slugId === 'ozempic-1mg' ? 'طلب طوارئ موجه لأقرب صيدليات شريكة بنطاق الدقي' : `تأكيد التوصيل من أقرب صيدلية شريكة على بُعد ${distanceM} متر`,
        rating: rating,
        distanceM: distanceM,
        price: price,
        status: status,
        isScarce: isScarce,
        isOutOfStock: isOutOfStock,
        generic_alternative: m.generic_alternative || null,
        alternative_price: m.alternative_price ? Number(m.alternative_price) : null,
        stock_quantity: stockQty,
        discount_percent: discountPercent,
        key: searchKey,
        created_at: m.created_at
      };
    });

    return { data: transformed, error: null };
  } catch (err) {
    console.error('[Elajk] Error fetching medicines from Supabase:', err);
    return { data: null, error: err };
  }
}
