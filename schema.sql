CREATE TABLE ksiegi_sort (
  wydania_id integer NOT NULL,
  ksiegi_id integer NOT NULL,
  sort integer NOT NULL,
  PRIMARY KEY (wydania_id,ksiegi_id)
);
CREATE INDEX idx_ksiegi_sort_sort on ksiegi_sort(sort);
CREATE TABLE notatnik (
  id integer primary key,
  insertdt datetime NOT NULL,
  nazwa varchar(45) NOT NULL,
  adres varchar(45) NOT NULL,
  opis text,
  wyrazenie varchar(255)
);
CREATE INDEX idx_notatnik_insertdt on notatnik(insertdt);
CREATE INDEX idx_notatnik_nazwa on notatnik(nazwa);
CREATE TABLE rodzaj (
  id integer primary key,
  nazwa varchar(45) NOT NULL,
  skrot varchar(45),
  id_nadrzedne integer
);
CREATE INDEX idx_rodzaj_nazwa on rodzaj(nazwa);
CREATE INDEX idx_rodzaj_id_nadrzedne on rodzaj(id_nadrzedne);
CREATE TABLE ksiegi (
  id integer primary key,
  rodzaj_id integer NOT NULL,
  nr integer NOT NULL,
  nazwa varchar(45),
  skrot varchar(45),
  url varchar(200),
  opis text,
  komentarz text,
  CONSTRAINT fk_ksiegi_rodzaj_id FOREIGN KEY (rodzaj_id) REFERENCES rodzaj (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_ksiegi_rodzaj_id on ksiegi(rodzaj_id);
CREATE INDEX idx_ksiegi_nr on ksiegi(nr);
CREATE INDEX idx_ksiegi_nazwa on ksiegi(nazwa);
CREATE INDEX idx_ksiegi_skrot on ksiegi(skrot);
CREATE TABLE wersety (
  id integer primary key,
  wydanie_id integer NOT NULL,
  rodzaj_id integer NOT NULL,
  ksiega_id integer NOT NULL,
  rozdzial integer NOT NULL,
  wers integer NOT NULL,
  tresc text NOT NULL,
  tytul1 varchar(255),
  tytul2 varchar(255),
  interpretacja text,
  url varchar(200),
  CONSTRAINT fk_wersety_ksiega FOREIGN KEY (ksiega_id) REFERENCES ksiegi (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_wersety_rodzaj FOREIGN KEY (rodzaj_id) REFERENCES rodzaj (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_wersety_wydanie FOREIGN KEY (wydanie_id) REFERENCES wydania (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX idx_wersety_wydanie_id on wersety(wydanie_id);
CREATE INDEX idx_wersety_rodzaj_id on wersety(rodzaj_id);
CREATE INDEX idx_wersety_ksiega_id on wersety(ksiega_id);
CREATE INDEX idx_wersety_rozdzial on wersety(rozdzial);
CREATE INDEX idx_wersety_wers on wersety(wers);
CREATE INDEX idx_wersety_tresc on wersety(tresc);
CREATE TABLE wydania (
  id integer primary key,
  rodzaj_id integer,
  data_importu date NOT NULL,
  nazwa varchar(45) NOT NULL,
  url varchar(200),
  opis text,
  komentarz text,
  sort_ksiegi_nazwa integer NOT NULL DEFAULT 0
);
CREATE INDEX idx_wydania_nazwa on wydania(nazwa);
