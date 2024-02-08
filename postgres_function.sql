-- veritabaınında gün içinde değişen verileri yazmak için kullanılır
-- gün içerisinde tekrar tekrar çalıştırıldığında aynı verinin çoklamaması amaçlanmıştır
CREATE OR REPLACE FUNCTION insert_into_deprem()
RETURNS VOID AS $$
BEGIN
    INSERT INTO public.deprem
    ("date", "time", "depth", magnitude, "location", poly)
    SELECT 
        tarih::date AS date,
        (split_part(saat, ':', 1) || ':' || split_part(saat, ':', 2))::TIME AS time,
        ROUND(derinlik::numeric, 2) AS depth,
        ROUND(buyukluk::numeric, 2) AS magnitude,
        yer AS location,
        ST_Point(ROUND(boylam::numeric, 4), ROUND(enlem::numeric, 4)) AS poly
    FROM deprem_son1gun ds
    LEFT JOIN deprem d ON d.date = ds.tarih::date AND d.time = (split_part(ds.saat, ':', 1) || ':' || split_part(ds.saat, ':', 2))::TIME
    WHERE d.id IS NULL;
END;
$$ LANGUAGE plpgsql;

-- verilerin tutulduğu ana tablo DDL
CREATE TABLE public.deprem (
	id serial4 NOT NULL,
	"date" date NULL,
	"time" time NULL,
	"depth" numeric NULL,
	magnitude numeric NULL,
	"location" varchar NULL,
	poly public.geometry NULL,
	CONSTRAINT deprem_pk PRIMARY KEY (id)
);