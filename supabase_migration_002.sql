-- =========================================================================
-- ELAJK MIGRATION 002: Add UI-critical columns to medicines table
-- PURPOSE: Store slug IDs, type, category, price, and UI metadata so the
--          frontend can replace the hardcoded DRUG_CATALOG entirely.
-- SAFE: All operations are non-destructive (ADD COLUMN, UPDATE existing rows).
-- =========================================================================

-- 1. Add new columns (IF NOT EXISTS prevents errors on re-run)
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS slug text UNIQUE;
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS counterpart_slug text;
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS type text DEFAULT 'original';
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS category text;
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS category_name text;
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS price numeric(10,2);
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS distance_m integer DEFAULT 350;
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS rating text;
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS search_key text;
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS savings text;
ALTER TABLE medicines ADD COLUMN IF NOT EXISTS match_score text DEFAULT '100%';

-- 2. Create index on slug for fast lookups
CREATE INDEX IF NOT EXISTS idx_medicines_slug ON medicines (slug);

-- 3. Populate all 33 rows with exact DRUG_CATALOG values
-- ═══════════════════════════════════════════════════════
-- Cardiovascular / Pressure
-- ═══════════════════════════════════════════════════════
UPDATE medicines SET
  slug = 'concor-5',
  counterpart_slug = 'bistol-5',
  type = 'original',
  category = 'cardio',
  category_name = 'أدوية الضغط والقلب',
  price = 56.50,
  distance_m = 350,
  rating = '★ 4.9 (140+ تقييم)',
  search_key = 'كونكور بيسوبرولول ضغط قلب',
  savings = NULL,
  match_score = NULL
WHERE id = '54bc1ec8-ab9b-4d7b-ad76-4a51f571b327';

UPDATE medicines SET
  slug = 'bistol-5',
  counterpart_slug = 'concor-5',
  type = 'generic',
  category = 'cardio',
  category_name = 'أدوية الضغط والقلب',
  price = 28.00,
  distance_m = 500,
  rating = '★ 4.8 (95+ تقييم)',
  search_key = 'كونكور بستول بيستول بيسوبرولول',
  savings = 'وفر 50%',
  match_score = '100%'
WHERE id = '1c9f8fc7-59a4-4e6b-a100-d3949da03435';

UPDATE medicines SET
  slug = 'exforge-5-160',
  counterpart_slug = 'amblopress-5-160',
  type = 'original',
  category = 'cardio',
  category_name = 'أدوية الضغط والقلب',
  price = 165.00,
  distance_m = 400,
  rating = '★ 4.9 (110+ تقييم)',
  search_key = 'إكسفورج أملوديبين فالسارتان ضغط',
  savings = NULL,
  match_score = NULL
WHERE id = '24befff3-e700-4c2e-ada0-12de72bdddaa';

UPDATE medicines SET
  slug = 'amblopress-5-160',
  counterpart_slug = 'exforge-5-160',
  type = 'generic',
  category = 'cardio',
  category_name = 'أدوية الضغط والقلب',
  price = 95.00,
  distance_m = 650,
  rating = '★ 4.8 (85+ تقييم)',
  search_key = 'إكسفورج أمبلوبريس فالسارتان',
  savings = 'وفر 42%',
  match_score = '100%'
WHERE id = 'ee868313-e900-4101-a491-c14089d762f6';

UPDATE medicines SET
  slug = 'inderal-10',
  counterpart_slug = 'propranolol-10',
  type = 'original',
  category = 'cardio',
  category_name = 'أدوية الضغط والقلب',
  price = 32.00,
  distance_m = 420,
  rating = '★ 4.9 (160+ تقييم)',
  search_key = 'أندرال انيدرال بروبرانولول ضربات القلب',
  savings = NULL,
  match_score = NULL
WHERE id = '680384ed-7604-4ebd-a07b-208d03f94f05';

UPDATE medicines SET
  slug = 'propranolol-10',
  counterpart_slug = 'inderal-10',
  type = 'generic',
  category = 'cardio',
  category_name = 'أدوية الضغط والقلب',
  price = 17.50,
  distance_m = 620,
  rating = '★ 4.7 (75+ تقييم)',
  search_key = 'أندرال بروبرانولول',
  savings = 'وفر 45%',
  match_score = '100%'
WHERE id = 'e13de3e1-5a9e-48af-a533-c75cb19a1b4a';

-- ═══════════════════════════════════════════════════════
-- Diabetes & Thyroid
-- ═══════════════════════════════════════════════════════
UPDATE medicines SET
  slug = 'galvus-met-50-1000',
  counterpart_slug = 'glucovamet-50-1000',
  type = 'original',
  category = 'diabetes',
  category_name = 'السكر والغدد',
  price = 180.00,
  distance_m = 550,
  rating = '★ 4.9 (175+ تقييم)',
  search_key = 'جالفس ميت جالفز فيلداجليبتين ميتفورمين سكر',
  savings = NULL,
  match_score = NULL
WHERE id = 'f78196b3-dc0b-4bcd-ac43-6ae08c7d7f9d';

UPDATE medicines SET
  slug = 'glucovamet-50-1000',
  counterpart_slug = 'galvus-met-50-1000',
  type = 'generic',
  category = 'diabetes',
  category_name = 'السكر والغدد',
  price = 110.00,
  distance_m = 700,
  rating = '★ 4.8 (90+ تقييم)',
  search_key = 'جالفس جلوكوفاميت جلوكوڤاميت سكر',
  savings = 'وفر 39%',
  match_score = '100%'
WHERE id = '8bd808aa-010f-42dc-aeb1-5e7386e98069';

UPDATE medicines SET
  slug = 'cidophage-850',
  counterpart_slug = 'metformin-850',
  type = 'original',
  category = 'diabetes',
  category_name = 'السكر والغدد',
  price = 24.00,
  distance_m = 300,
  rating = '★ 4.8 (130+ تقييم)',
  search_key = 'سيدوفاج ميتفورمين سكر تخسيس',
  savings = NULL,
  match_score = NULL
WHERE id = 'b432f36b-00d7-4e4d-a105-72a3955a24d5';

UPDATE medicines SET
  slug = 'metformin-850',
  counterpart_slug = 'cidophage-850',
  type = 'generic',
  category = 'diabetes',
  category_name = 'السكر والغدد',
  price = 15.00,
  distance_m = 480,
  rating = '★ 4.7 (75+ تقييم)',
  search_key = 'سيدوفاج ميتفورمين سكر',
  savings = 'وفر 38%',
  match_score = '100%'
WHERE id = '16f19ea1-9f07-46be-ad02-fdc7e26962e7';

UPDATE medicines SET
  slug = 'euthyrox-100',
  counterpart_slug = 'thyroxin-100',
  type = 'original',
  category = 'diabetes',
  category_name = 'السكر والغدد',
  price = 90.00,
  distance_m = 650,
  rating = '★ 4.9 (240+ تقييم)',
  search_key = 'إيوتيروكس يوثيروكس ليفوثيروكسين غدة درقية',
  savings = NULL,
  match_score = NULL
WHERE id = '1a803011-17d9-4094-af65-7dd86309fe36';

UPDATE medicines SET
  slug = 'thyroxin-100',
  counterpart_slug = 'euthyrox-100',
  type = 'generic',
  category = 'diabetes',
  category_name = 'السكر والغدد',
  price = 48.00,
  distance_m = 820,
  rating = '★ 4.8 (110+ تقييم)',
  search_key = 'إيوتيروكس ثايروكسين ثيروكسين غدة',
  savings = 'وفر 47%',
  match_score = '100%'
WHERE id = '9401c434-624b-48bd-a218-a36c53bb672f';

-- ═══════════════════════════════════════════════════════
-- Antibiotics & Antivirals
-- ═══════════════════════════════════════════════════════
UPDATE medicines SET
  slug = 'augmentin-1g',
  counterpart_slug = 'emoxclav-1g',
  type = 'original',
  category = 'antibiotics',
  category_name = 'المضادات والفيروسات',
  price = 99.00,
  distance_m = 600,
  rating = '★ 4.9 (180+ تقييم)',
  search_key = 'أوجمنتين اوجمنتين أموكسيسيلين مضاد حيوي',
  savings = NULL,
  match_score = NULL
WHERE id = 'd93599fe-22ef-4e36-ae12-1b069f0bcc52';

UPDATE medicines SET
  slug = 'emoxclav-1g',
  counterpart_slug = 'augmentin-1g',
  type = 'generic',
  category = 'antibiotics',
  category_name = 'المضادات والفيروسات',
  price = 62.00,
  distance_m = 750,
  rating = '★ 4.8 (115+ تقييم)',
  search_key = 'أوجمنتين إيموكسكلاف ايموكسكلاف مضاد',
  savings = 'وفر 37%',
  match_score = '100%'
WHERE id = '9c19efb6-4f40-4e9f-a566-886be5c9ff7b';

UPDATE medicines SET
  slug = 'klavox-625',
  counterpart_slug = 'megamox-625',
  type = 'original',
  category = 'antibiotics',
  category_name = 'المضادات والفيروسات',
  price = 75.00,
  distance_m = 800,
  rating = '★ 4.8 (95+ تقييم)',
  search_key = 'كلافوكس أموكسيسيلين مضاد',
  savings = NULL,
  match_score = NULL
WHERE id = '06258f48-2f8d-4e2b-a905-0668c8aeb7d0';

UPDATE medicines SET
  slug = 'megamox-625',
  counterpart_slug = 'klavox-625',
  type = 'generic',
  category = 'antibiotics',
  category_name = 'المضادات والفيروسات',
  price = 48.00,
  distance_m = 950,
  rating = '★ 4.7 (70+ تقييم)',
  search_key = 'كلافوكس ميغاموكس ميجاموكس',
  savings = 'وفر 36%',
  match_score = '100%'
WHERE id = 'b0d417b6-bf5a-4710-af43-fbc33bc6dd55';

UPDATE medicines SET
  slug = 'zovirax-400',
  counterpart_slug = 'cycloviral-400',
  type = 'original',
  category = 'antibiotics',
  category_name = 'المضادات والفيروسات',
  price = 120.00,
  distance_m = 490,
  rating = '★ 4.9 (185+ تقييم)',
  search_key = 'زوفيراكس اسيكلوفير فيروسات هربس',
  savings = NULL,
  match_score = NULL
WHERE id = '63001216-5170-4af8-aa47-b5d85bed16c7';

UPDATE medicines SET
  slug = 'cycloviral-400',
  counterpart_slug = 'zovirax-400',
  type = 'generic',
  category = 'antibiotics',
  category_name = 'المضادات والفيروسات',
  price = 65.00,
  distance_m = 680,
  rating = '★ 4.8 (80+ تقييم)',
  search_key = 'زوفيراكس سيكلوفيرال اسيكلوفير',
  savings = 'وفر 46%',
  match_score = '100%'
WHERE id = '981e368b-2451-42e3-a70c-c74582e5484c';

-- ═══════════════════════════════════════════════════════
-- Gastrointestinal & Neuro
-- ═══════════════════════════════════════════════════════
UPDATE medicines SET
  slug = 'omeprez-20',
  counterpart_slug = 'helicure-20',
  type = 'original',
  category = 'gastro',
  category_name = 'الجهاز الهضمي والأعصاب',
  price = 68.00,
  distance_m = 420,
  rating = '★ 4.9 (135+ تقييم)',
  search_key = 'أومبريز اومبريز أوميبرازول معدة حموضة',
  savings = NULL,
  match_score = NULL
WHERE id = '17965bd0-923e-4bf3-a1d6-fdfaa98f20c3';

UPDATE medicines SET
  slug = 'helicure-20',
  counterpart_slug = 'omeprez-20',
  type = 'generic',
  category = 'gastro',
  category_name = 'الجهاز الهضمي والأعصاب',
  price = 39.00,
  distance_m = 560,
  rating = '★ 4.8 (88+ تقييم)',
  search_key = 'أومبريز هيليكير هيليكيور أوميبرازول معدة',
  savings = 'وفر 43%',
  match_score = '100%'
WHERE id = 'baaa546c-41da-43a4-a37d-98036a7821fe';

UPDATE medicines SET
  slug = 'controloc-40',
  counterpart_slug = 'zurcal-40',
  type = 'original',
  category = 'gastro',
  category_name = 'الجهاز الهضمي والأعصاب',
  price = 140.00,
  distance_m = 380,
  rating = '★ 4.9 (210+ تقييم)',
  search_key = 'كونترولوك بانتوبرازول معدة ارتجاع حموضة',
  savings = NULL,
  match_score = NULL
WHERE id = 'a33db4ae-b9b0-4f92-aae7-11cbfa630160';

UPDATE medicines SET
  slug = 'zurcal-40',
  counterpart_slug = 'controloc-40',
  type = 'generic',
  category = 'gastro',
  category_name = 'الجهاز الهضمي والأعصاب',
  price = 78.00,
  distance_m = 520,
  rating = '★ 4.8 (95+ تقييم)',
  search_key = 'كونترولوك زوركال بانتوبرازول معدة',
  savings = 'وفر 44%',
  match_score = '100%'
WHERE id = 'f13e23f5-0199-4d07-a3d2-9f1dc4bd8c7e';

UPDATE medicines SET
  slug = 'tegretol-200',
  counterpart_slug = 'mazepine-200',
  type = 'original',
  category = 'gastro',
  category_name = 'الجهاز الهضمي والأعصاب',
  price = 48.00,
  distance_m = 410,
  rating = '★ 4.9 (160+ تقييم)',
  search_key = 'تجريتول كاربامازيبين أعصاب تشنجات',
  savings = NULL,
  match_score = NULL
WHERE id = '62f0af73-fd7b-4aa7-a034-e3856a738fbf';

UPDATE medicines SET
  slug = 'mazepine-200',
  counterpart_slug = 'tegretol-200',
  type = 'generic',
  category = 'gastro',
  category_name = 'الجهاز الهضمي والأعصاب',
  price = 26.00,
  distance_m = 580,
  rating = '★ 4.7 (65+ تقييم)',
  search_key = 'تجريتول مازيبين كاربامازيبين',
  savings = 'وفر 46%',
  match_score = '100%'
WHERE id = '2e47f85f-944a-43ce-a150-adeaacc34a1f';

-- ═══════════════════════════════════════════════════════
-- Analgesics, Asthma & Respiratory
-- ═══════════════════════════════════════════════════════
UPDATE medicines SET
  slug = 'aspirin-protect-100',
  counterpart_slug = 'egypirin-100',
  type = 'original',
  category = 'analgesics',
  category_name = 'المسكنات والربو',
  price = 36.00,
  distance_m = 450,
  rating = '★ 4.9 (210+ تقييم)',
  search_key = 'أسبرين اسبرين حماية القلب سيولة بروتكت',
  savings = NULL,
  match_score = NULL
WHERE id = '70d8d985-c856-4fb3-a086-519c96e3cb9f';

UPDATE medicines SET
  slug = 'egypirin-100',
  counterpart_slug = 'aspirin-protect-100',
  type = 'generic',
  category = 'analgesics',
  category_name = 'المسكنات والربو',
  price = 18.00,
  distance_m = 600,
  rating = '★ 4.8 (95+ تقييم)',
  search_key = 'أسبرين إيجيبيرين ايجيبيرين سيولة',
  savings = 'وفر 50%',
  match_score = '100%'
WHERE id = '05ac016e-aa66-44a8-aa81-ee52a99d397f';

UPDATE medicines SET
  slug = 'cataflam-50',
  counterpart_slug = 'diclofen-50',
  type = 'original',
  category = 'analgesics',
  category_name = 'المسكنات والربو',
  price = 42.00,
  distance_m = 380,
  rating = '★ 4.9 (290+ تقييم)',
  search_key = 'كتافلام كتافلام كتَافلام ديكلوفيناك مسكن',
  savings = NULL,
  match_score = NULL
WHERE id = 'ba6fb676-4535-4c0c-aeba-e92c88e61152';

UPDATE medicines SET
  slug = 'diclofen-50',
  counterpart_slug = 'cataflam-50',
  type = 'generic',
  category = 'analgesics',
  category_name = 'المسكنات والربو',
  price = 22.00,
  distance_m = 520,
  rating = '★ 4.8 (145+ تقييم)',
  search_key = 'كتافلام ديكلوفين ديكلوفيناك مسكن',
  savings = 'وفر 48%',
  match_score = '100%'
WHERE id = '5e2905c9-ff28-40b0-a279-a17cce5e3f66';

UPDATE medicines SET
  slug = 'ventolin-inhaler',
  counterpart_slug = 'farcolin-inhaler',
  type = 'original',
  category = 'analgesics',
  category_name = 'المسكنات والربو',
  price = 85.00,
  distance_m = 470,
  rating = '★ 4.9 (220+ تقييم)',
  search_key = 'فنتولين بخاخ سالبيوتامول حساسية صدر ربو',
  savings = NULL,
  match_score = NULL
WHERE id = '70a0e0d1-9fcc-4e0d-a9f0-cf4e16a49ab8';

UPDATE medicines SET
  slug = 'farcolin-inhaler',
  counterpart_slug = 'ventolin-inhaler',
  type = 'generic',
  category = 'analgesics',
  category_name = 'المسكنات والربو',
  price = 44.00,
  distance_m = 610,
  rating = '★ 4.8 (105+ تقييم)',
  search_key = 'فنتولين فاركولين بخاخ سالبيوتامول',
  savings = 'وفر 48%',
  match_score = '100%'
WHERE id = 'b91d6304-754c-4952-aefc-579f3d1a5042';

UPDATE medicines SET
  slug = 'mucophylline-syrup',
  counterpart_slug = 'bronchofin-syrup',
  type = 'original',
  category = 'analgesics',
  category_name = 'المسكنات والربو',
  price = 30.00,
  distance_m = 430,
  rating = '★ 4.8 (115+ تقييم)',
  search_key = 'ميوكوفيلين شراب كحة بلغم حساسية',
  savings = NULL,
  match_score = NULL
WHERE id = '88655c08-6002-4559-abd9-18eb3ded832a';

UPDATE medicines SET
  slug = 'bronchofin-syrup',
  counterpart_slug = 'mucophylline-syrup',
  type = 'generic',
  category = 'analgesics',
  category_name = 'المسكنات والربو',
  price = 17.00,
  distance_m = 590,
  rating = '★ 4.7 (80+ تقييم)',
  search_key = 'ميوكوفيلين برونكوفين برونكوفان شراب كحة',
  savings = 'وفر 43%',
  match_score = '100%'
WHERE id = 'cf4b12ba-75e1-4722-a969-b11da0aa1c08';

-- ═══════════════════════════════════════════════════════
-- Emergency Shortage Items
-- ═══════════════════════════════════════════════════════
UPDATE medicines SET
  slug = 'ozempic-1mg',
  counterpart_slug = NULL,
  type = 'original',
  category = 'diabetes',
  category_name = 'السكر والغدد',
  price = 3800.00,
  distance_m = 5000,
  rating = '★ 5.0 (410+ تقييم)',
  search_key = 'أوزمبك اوزمبك سيماجلوتيد سكر تخسيس قلم',
  savings = NULL,
  match_score = NULL
WHERE id = 'd7a55070-3db1-45f6-a2b4-28b24293f263';

-- 4. Verify: count rows with slug populated
-- SELECT count(*) FROM medicines WHERE slug IS NOT NULL;
-- Expected: 33
