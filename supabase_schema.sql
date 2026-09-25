-- =========================================================================
-- ELAJK (علاجك) SUPABASE DATABASE SCHEMA & SEED MIGRATION
-- Compatible with Supabase PostgreSQL & Row Level Security (RLS)
-- =========================================================================

-- 1. Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Create Medicines Table
CREATE TABLE IF NOT EXISTS medicines (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  active_ingredient text,
  is_available boolean DEFAULT true,
  generic_alternative text,
  alternative_price numeric(10,2),
  created_at timestamptz DEFAULT now()
);

-- 3. Create Pharmacies Stock Table
CREATE TABLE IF NOT EXISTS pharmacies_stock (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  pharmacy_name text NOT NULL,
  medicine_id uuid NOT NULL REFERENCES medicines(id) ON DELETE CASCADE,
  stock_quantity integer DEFAULT 0,
  discount_percent numeric(5,2) DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- 4. Create Performance Indexes
CREATE INDEX IF NOT EXISTS idx_medicines_name ON medicines (name);
CREATE INDEX IF NOT EXISTS idx_medicines_active_ingredient ON medicines (active_ingredient);
CREATE INDEX IF NOT EXISTS idx_medicines_is_available ON medicines (is_available);
CREATE INDEX IF NOT EXISTS idx_pharmacies_stock_medicine_id ON pharmacies_stock (medicine_id);
CREATE INDEX IF NOT EXISTS idx_pharmacies_stock_pharmacy_name ON pharmacies_stock (pharmacy_name);

-- 5. Enable Row Level Security (RLS)
ALTER TABLE medicines ENABLE ROW LEVEL SECURITY;
ALTER TABLE pharmacies_stock ENABLE ROW LEVEL SECURITY;

-- 6. Public Read-Only Security Policies (Anonymous & Authenticated Users)
DROP POLICY IF EXISTS "Allow public read-only access to medicines" ON medicines;
CREATE POLICY "Allow public read-only access to medicines"
  ON medicines
  FOR SELECT
  TO anon, authenticated
  USING (true);

DROP POLICY IF EXISTS "Allow public read-only access to pharmacies_stock" ON pharmacies_stock;
CREATE POLICY "Allow public read-only access to pharmacies_stock"
  ON pharmacies_stock
  FOR SELECT
  TO anon, authenticated
  USING (true);

-- 7. Seed Initial Mock Data (Preserving all 33 Egyptian medicines & shortage alternatives)
INSERT INTO medicines (id, name, active_ingredient, is_available, generic_alternative, alternative_price)
VALUES
  ('54bc1ec8-ab9b-4d7b-ad76-4a51f571b327', 'كونكور 5 مجم (Concor 5mg)', 'بيسوبرولول فومارات (Bisoprolol 5mg)', true, 'بستول 5 مجم (Bistol 5mg)', 28.00),
  ('1c9f8fc7-59a4-4e6b-a100-d3949da03435', 'بستول 5 مجم (Bistol 5mg)', 'بيسوبرولول فومارات (Bisoprolol 5mg)', true, 'كونكور 5 مجم (Concor 5mg)', 56.50),
  ('24befff3-e700-4c2e-ada0-12de72bdddaa', 'إكسفورج 5/160 (Exforge 5/160)', 'أملوديبين 5 ملغ + فالسارتان 160 ملغ', true, 'أمبلوبريس 5/160 (Amblopress 5/160)', 95.00),
  ('ee868313-e900-4101-a491-c14089d762f6', 'أمبلوبريس 5/160 (Amblopress 5/160)', 'أملوديبين 5 ملغ + فالسارتان 160 ملغ', true, 'إكسفورج 5/160 (Exforge 5/160)', 165.00),
  ('680384ed-7604-4ebd-a07b-208d03f94f05', 'أندرال 10 مجم (Inderal 10mg)', 'بروبرانولول هيدروكلوريد 10 ملغ (Propranolol HCl)', true, 'بروبرانولول 10 (Propranolol 10)', 17.50),
  ('e13de3e1-5a9e-48af-a533-c75cb19a1b4a', 'بروبرانولول 10 (Propranolol 10)', 'بروبرانولول هيدروكلوريد 10 ملغ (Propranolol HCl)', true, 'أندرال 10 مجم (Inderal 10mg)', 32.00),
  ('f78196b3-dc0b-4bcd-ac43-6ae08c7d7f9d', 'جالفس ميت 50/1000 (Galvus Met)', 'فيلداجليبتين 50 ملغ + ميتفورمين 1000 ملغ', true, 'جلوكوڤاميت 50/1000 (Glucovamet)', 110.00),
  ('8bd808aa-010f-42dc-aeb1-5e7386e98069', 'جلوكوڤاميت 50/1000 (Glucovamet)', 'فيلداجليبتين 50 ملغ + ميتفورمين 1000 ملغ', true, 'جالفس ميت 50/1000 (Galvus Met)', 180.00),
  ('b432f36b-00d7-4e4d-a105-72a3955a24d5', 'سيدوفاج 850 (Cidophage 850)', 'ميتفورمين هيدروكلوريد (Metformin HCl 850mg)', true, 'ميتفورمين 850 (Metformin 850)', 15.00),
  ('16f19ea1-9f07-46be-ad02-fdc7e26962e7', 'ميتفورمين 850 (Metformin 850)', 'ميتفورمين هيدروكلوريد (Metformin HCl 850mg)', true, 'سيدوفاج 850 (Cidophage 850)', 24.00),
  ('1a803011-17d9-4094-af65-7dd86309fe36', 'إيوتيروكس 100 (Euthyrox 100)', 'ليفوثيروكسين صوديوم (Levothyroxine Sodium 100mcg)', true, 'ثايروكسين 100 (Thyroxin 100)', 48.00),
  ('9401c434-624b-48bd-a218-a36c53bb672f', 'ثايروكسين 100 (Thyroxin 100)', 'ليفوثيروكسين صوديوم (Levothyroxine Sodium 100mcg)', true, 'إيوتيروكس 100 (Euthyrox 100)', 90.00),
  ('d93599fe-22ef-4e36-ae12-1b069f0bcc52', 'أوجمنتين 1 جم (Augmentin 1g)', 'أموكسيسيلين 875 ملغ + حمض كلافولانيك 125 ملغ', true, 'إيموكسكلاف 1 جم (Emoxclav 1g)', 62.00),
  ('9c19efb6-4f40-4e9f-a566-886be5c9ff7b', 'إيموكسكلاف 1 جم (Emoxclav 1g)', 'أموكسيسيلين 875 ملغ + حمض كلافولانيك 125 ملغ', true, 'أوجمنتين 1 جم (Augmentin 1g)', 99.00),
  ('06258f48-2f8d-4e2b-a905-0668c8aeb7d0', 'كلافوكس 625 (Klavox 625)', 'أموكسيسيلين 500 ملغ + حمض كلافولانيك 125 ملغ', true, 'ميغاموكس 625 (Megamox 625)', 48.00),
  ('b0d417b6-bf5a-4710-af43-fbc33bc6dd55', 'ميغاموكس 625 (Megamox 625)', 'أموكسيسيلين 500 ملغ + حمض كلافولانيك 125 ملغ', true, 'كلافوكس 625 (Klavox 625)', 75.00),
  ('63001216-5170-4af8-aa47-b5d85bed16c7', 'زوفيراكس 400 (Zovirax 400)', 'أسيكلوفير 400 ملغ مضاد فيروسي (Acyclovir)', true, 'سيكلوفيرال 400 (Cycloviral 400)', 65.00),
  ('981e368b-2451-42e3-a70c-c74582e5484c', 'سيكلوفيرال 400 (Cycloviral 400)', 'أسيكلوفير 400 ملغ مضاد فيروسي (Acyclovir)', true, 'زوفيراكس 400 (Zovirax 400)', 120.00),
  ('17965bd0-923e-4bf3-a1d6-fdfaa98f20c3', 'أومبريز 20 (Omeprez 20)', 'أوميبرازول 20 ملغ (Omeprazole) لحموضة وقرحة المعدة', true, 'هيليكير 20 (Helicure 20)', 39.00),
  ('baaa546c-41da-43a4-a37d-98036a7821fe', 'هيليكير 20 (Helicure 20)', 'أوميبرازول 20 ملغ (Omeprazole) لحموضة وقرحة المعدة', true, 'أومبريز 20 (Omeprez 20)', 68.00),
  ('a33db4ae-b9b0-4f92-aae7-11cbfa630160', 'كونترولوك 40 (Controloc 40)', 'بانتوبرازول صوديوم 40 ملغ (Pantoprazole) للمعدة والارتجاع', true, 'زوركال 40 (Zurcal 40)', 78.00),
  ('f13e23f5-0199-4d07-a3d2-9f1dc4bd8c7e', 'زوركال 40 (Zurcal 40)', 'بانتوبرازول صوديوم 40 ملغ (Pantoprazole) للمعدة والارتجاع', true, 'كونترولوك 40 (Controloc 40)', 140.00),
  ('62f0af73-fd7b-4aa7-a034-e3856a738fbf', 'تجريتول 200 (Tegretol 200)', 'كاربامازيبين 200 ملغ للأعصاب والصرع (Carbamazepine)', true, 'مازيبين 200 (Mazepine 200)', 26.00),
  ('2e47f85f-944a-43ce-a150-adeaacc34a1f', 'مازيبين 200 (Mazepine 200)', 'كاربامازيبين 200 ملغ للأعصاب والصرع (Carbamazepine)', true, 'تجريتول 200 (Tegretol 200)', 48.00),
  ('70d8d985-c856-4fb3-a086-519c96e3cb9f', 'أسبرين لحماية القلب 100 (Aspirin Protect)', 'حمض أسيتيل ساليسيليك 100 ملغ للسيولة والوقاية', true, 'إيجيبيرين 100 (Egypirin 100)', 18.00),
  ('05ac016e-aa66-44a8-aa81-ee52a99d397f', 'إيجيبيرين 100 (Egypirin 100)', 'حمض أسيتيل ساليسيليك 100 ملغ للسيولة والوقاية', true, 'أسبرين لحماية القلب 100 (Aspirin Protect)', 36.00),
  ('ba6fb676-4535-4c0c-aeba-e92c88e61152', 'كتَافلام 50 (Cataflam 50)', 'ديكلوفيناك بوتاسيوم 50 ملغ مسكن ومضاد للالتهاب', true, 'ديكلوفين 50 (Diclofen 50)', 22.00),
  ('5e2905c9-ff28-40b0-a279-a17cce5e3f66', 'ديكلوفين 50 (Diclofen 50)', 'ديكلوفيناك بوتاسيوم 50 ملغ مسكن ومضاد للالتهاب', true, 'كتَافلام 50 (Cataflam 50)', 42.00),
  ('70a0e0d1-9fcc-4e0d-a9f0-cf4e16a49ab8', 'فنتولين بخاخ (Ventolin Inhaler)', 'سالبيوتامول 100 ميكروجرام موسع سريع للشعب الهوائية', true, 'فاركولين بخاخ (Farcolin Inhaler)', 44.00),
  ('b91d6304-754c-4952-aefc-579f3d1a5042', 'فاركولين بخاخ (Farcolin Inhaler)', 'سالبيوتامول 100 ميكروجرام موسع سريع للشعب الهوائية', true, 'فنتولين بخاخ (Ventolin Inhaler)', 85.00),
  ('88655c08-6002-4559-abd9-18eb3ded832a', 'ميوكوفيلين شراب (Mucophylline)', 'أسيفيلين بيبيرازين + برومهيكسين مذيب للبلغم وموسع للشعب', true, 'برونكوفين (Bronchofin)', 17.00),
  ('cf4b12ba-75e1-4722-a969-b11da0aa1c08', 'برونكوفين (Bronchofin)', 'أسيفيلين بيبيرازين + برومهيكسين مذيب للبلغم وموسع للشعب', true, 'ميوكوفيلين شراب (Mucophylline)', 30.00),
  ('d7a55070-3db1-45f6-a2b4-28b24293f263', 'أوزمبك 1 ملغ قلم حقن (Ozempic 1mg)', 'سيماجلوتيد (Semaglutide 1mg) لضبط السكر والوزن', false, NULL, NULL)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  active_ingredient = EXCLUDED.active_ingredient,
  is_available = EXCLUDED.is_available,
  generic_alternative = EXCLUDED.generic_alternative,
  alternative_price = EXCLUDED.alternative_price;

INSERT INTO pharmacies_stock (medicine_id, pharmacy_name, stock_quantity, discount_percent)
VALUES
  ('54bc1ec8-ab9b-4d7b-ad76-4a51f571b327', 'صيدلية شريكة رقم #402 — نطاق المعادي', 20, 50.44),
  ('1c9f8fc7-59a4-4e6b-a100-d3949da03435', 'صيدلية شريكة رقم #318 — نطاق دجلة المعادي', 45, 50.00),
  ('24befff3-e700-4c2e-ada0-12de72bdddaa', 'صيدلية شريكة رقم #204 — نطاق مصر الجديدة', 20, 42.42),
  ('ee868313-e900-4101-a491-c14089d762f6', 'صيدلية شريكة رقم #185 — نطاق النزهة', 45, 42.00),
  ('680384ed-7604-4ebd-a07b-208d03f94f05', 'صيدلية شريكة رقم #512 — نطاق مدينة نصر', 20, 45.31),
  ('e13de3e1-5a9e-48af-a533-c75cb19a1b4a', 'صيدلية شريكة رقم #340 — نطاق عباس العقاد', 45, 45.00),
  ('f78196b3-dc0b-4bcd-ac43-6ae08c7d7f9d', 'صيدلية شريكة رقم #512 — نطاق مدينة نصر', 20, 38.89),
  ('8bd808aa-010f-42dc-aeb1-5e7386e98069', 'صيدلية شريكة رقم #430 — نطاق مكرم عبيد', 45, 39.00),
  ('b432f36b-00d7-4e4d-a105-72a3955a24d5', 'صيدلية شريكة رقم #309 — نطاق شبرا', 20, 37.50),
  ('16f19ea1-9f07-46be-ad02-fdc7e26962e7', 'صيدلية شريكة رقم #216 — نطاق روض الفرج', 45, 38.00),
  ('1a803011-17d9-4094-af65-7dd86309fe36', 'صيدلية شريكة رقم #514 — نطاق التجمع الخامس', 2, 46.67),
  ('9401c434-624b-48bd-a218-a36c53bb672f', 'صيدلية شريكة رقم #362 — نطاق الرحاب', 45, 47.00),
  ('d93599fe-22ef-4e36-ae12-1b069f0bcc52', 'صيدلية شريكة رقم #408 — نطاق المهندسين', 3, 37.37),
  ('9c19efb6-4f40-4e9f-a566-886be5c9ff7b', 'صيدلية شريكة رقم #290 — نطاق الدقي', 45, 37.00),
  ('06258f48-2f8d-4e2b-a905-0668c8aeb7d0', 'صيدلية شريكة رقم #315 — نطاق 6 أكتوبر', 20, 36.00),
  ('b0d417b6-bf5a-4710-af43-fbc33bc6dd55', 'صيدلية شريكة رقم #188 — نطاق الشيخ زايد', 45, 36.00),
  ('63001216-5170-4af8-aa47-b5d85bed16c7', 'صيدلية شريكة رقم #601 — وسط البلد', 20, 45.83),
  ('981e368b-2451-42e3-a70c-c74582e5484c', 'صيدلية شريكة رقم #219 — نطاق عابدين', 45, 46.00),
  ('17965bd0-923e-4bf3-a1d6-fdfaa98f20c3', 'صيدلية شريكة رقم #112 — نطاق الزمالك', 20, 42.65),
  ('baaa546c-41da-43a4-a37d-98036a7821fe', 'صيدلية شريكة رقم #205 — نطاق العجوزة', 45, 43.00),
  ('a33db4ae-b9b0-4f92-aae7-11cbfa630160', 'صيدلية شريكة رقم #419 — نطاق جاردن سيتي', 20, 44.29),
  ('f13e23f5-0199-4d07-a3d2-9f1dc4bd8c7e', 'صيدلية شريكة رقم #328 — نطاق المنيل', 45, 44.00),
  ('62f0af73-fd7b-4aa7-a034-e3856a738fbf', 'صيدلية شريكة رقم #402 — نطاق المعادي', 20, 45.83),
  ('2e47f85f-944a-43ce-a150-adeaacc34a1f', 'صيدلية شريكة رقم #215 — نطاق البساتين', 45, 46.00),
  ('70d8d985-c856-4fb3-a086-519c96e3cb9f', 'صيدلية شريكة رقم #105 — نطاق الدقي', 20, 50.00),
  ('05ac016e-aa66-44a8-aa81-ee52a99d397f', 'صيدلية شريكة رقم #220 — نطاق التجمع الأول', 45, 50.00),
  ('ba6fb676-4535-4c0c-aeba-e92c88e61152', 'صيدلية شريكة رقم #419 — نطاق وسط البلد', 20, 47.62),
  ('5e2905c9-ff28-40b0-a279-a17cce5e3f66', 'صيدلية شريكة رقم #328 — نطاق جاردن سيتي', 45, 48.00),
  ('70a0e0d1-9fcc-4e0d-a9f0-cf4e16a49ab8', 'صيدلية شريكة رقم #212 — نطاق المقطم', 20, 48.24),
  ('b91d6304-754c-4952-aefc-579f3d1a5042', 'صيدلية شريكة رقم #145 — نطاق المعراج', 45, 48.00),
  ('88655c08-6002-4559-abd9-18eb3ded832a', 'صيدلية شريكة رقم #308 — نطاق فيصل', 20, 43.33),
  ('cf4b12ba-75e1-4722-a969-b11da0aa1c08', 'صيدلية شريكة رقم #201 — نطاق الهرم', 45, 43.00),
  ('d7a55070-3db1-45f6-a2b4-28b24293f263', 'صيدلية شريكة رقم #814 — نطاق الدقي', 0, 0.00);
