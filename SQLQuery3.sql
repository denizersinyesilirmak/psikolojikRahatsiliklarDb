-- Ana Tablolar

CREATE TABLE Hastalar (
    hasta_id INT NOT NULL PRIMARY KEY,
    adi NVARCHAR(100) NOT NULL,
    soyadi NVARCHAR(100) NOT NULL,
    dogum_tarihi DATE,
    cinsiyet CHAR(1),
    eposta NVARCHAR(255),
    adres NVARCHAR(500),
    kayit_tarihi DATE
);

CREATE TABLE GenelHayat (
    hayat_id INT NOT NULL PRIMARY KEY,
    meslek NVARCHAR(100),
    egitim_durumu NVARCHAR(100),
    ekonomik_kosul NVARCHAR(100),
    stres NVARCHAR(100),
    hasta_id INT NOT NULL,
    CONSTRAINT FK_GenelHayat_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id)
);

CREATE TABLE HastaGecmis (
    gecmis_id INT NOT NULL PRIMARY KEY,
    intihar_gecmis BIT,
    alkol_kullanimi BIT,
    aciklama NVARCHAR(MAX),
    hasta_id INT NOT NULL,
    CONSTRAINT FK_HastaGecmis_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id)
);

CREATE TABLE Teshis (
    teshis_id INT NOT NULL PRIMARY KEY,
    aciklama NVARCHAR(MAX)
);

CREATE TABLE HastalikBelirtileri (
    belirti_id INT NOT NULL PRIMARY KEY,
    belirti_adi NVARCHAR(255),
    siddeti NVARCHAR(50),
    baslangic_tarihi DATE
);

CREATE TABLE RiskFaktorleri (
    risk_id INT NOT NULL PRIMARY KEY,
    faktor_tipi NVARCHAR(100),
    aciklama NVARCHAR(MAX),
    onlem_plani NVARCHAR(MAX)
);

CREATE TABLE IlerlemeKayitlari (
    kayit_id INT NOT NULL PRIMARY KEY,
    tarihi DATE,
    gelisme_durumu NVARCHAR(MAX),
    olcek_skoru INT,
    hasta_id INT NOT NULL,
    psikiyatrist_id INT NOT NULL,
    tedavi_id INT NOT NULL,
    CONSTRAINT FK_IlerlemeKayitlari_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id),
    CONSTRAINT FK_IlerlemeKayitlari_Psikiyatrist FOREIGN KEY (psikiyatrist_id) REFERENCES Psikiyatrist(psikiyatrist_id),
    CONSTRAINT FK_IlerlemeKayitlari_TedaviYontemleri FOREIGN KEY (tedavi_id) REFERENCES TedaviYontemleri(yontem_id)
);

CREATE TABLE Seanslar (
    seans_id INT NOT NULL PRIMARY KEY,
    tarihi DATE,
    suresi INT,
    tutulan_notlar NVARCHAR(MAX),
    hasta_id INT NOT NULL,
    psikiyatrist_id INT NOT NULL,
    CONSTRAINT FK_Seanslar_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id),
    CONSTRAINT FK_Seanslar_Psikiyatrist FOREIGN KEY (psikiyatrist_id) REFERENCES Psikiyatrist(psikiyatrist_id)
);

CREATE TABLE Receteler (
    recete_id INT NOT NULL PRIMARY KEY,
    kullanim_sikligi NVARCHAR(100),
    baslangic_tarihi DATE,
    hasta_id INT NOT NULL,
    psikiyatrist_id INT NOT NULL,
    kayit_id INT NOT NULL,
    CONSTRAINT FK_Receteler_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id),
    CONSTRAINT FK_Receteler_Psikiyatrist FOREIGN KEY (psikiyatrist_id) REFERENCES Psikiyatrist(psikiyatrist_id),
    CONSTRAINT FK_Receteler_IlerlemeKayitlari FOREIGN KEY (kayit_id) REFERENCES IlerlemeKayitlari(kayit_id)
);

CREATE TABLE TestSonuclari (
    sonuc_id INT NOT NULL PRIMARY KEY,
    sonucu NVARCHAR(MAX),
    yorumu NVARCHAR(MAX),
    tarihi DATE,
    test_id INT NOT NULL,
    psikiyatrist_id INT NOT NULL,
    CONSTRAINT FK_TestSonuclari_Testler FOREIGN KEY (test_id) REFERENCES Testler(test_id),
    CONSTRAINT FK_TestSonuclari_Psikiyatrist FOREIGN KEY (psikiyatrist_id) REFERENCES Psikiyatrist(psikiyatrist_id)
);

CREATE TABLE Psikiyatrist (
    psikiyatrist_id INT NOT NULL PRIMARY KEY,
    adi NVARCHAR(100),
    soyadi NVARCHAR(100),
    calisma_yeri NVARCHAR(255)
);

CREATE TABLE TedaviYontemleri (
    yontem_id INT NOT NULL PRIMARY KEY,
    turu NVARCHAR(100),
    baslangic_tarihi DATE,
    durumu NVARCHAR(100),
    hasta_id INT NOT NULL,
    gecmis_id INT NOT NULL,
    hayat_id INT NOT NULL,
    CONSTRAINT FK_TedaviYontemleri_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id),
    CONSTRAINT FK_TedaviYontemleri_HastaGecmis FOREIGN KEY (gecmis_id) REFERENCES HastaGecmis(gecmis_id),
    CONSTRAINT FK_TedaviYontemleri_GenelHayat FOREIGN KEY (hayat_id) REFERENCES GenelHayat(hayat_id)
);

CREATE TABLE Testler (
    test_id INT NOT NULL PRIMARY KEY,
    test_adi NVARCHAR(255),
    amac NVARCHAR(MAX)
);

-- Ýliþkisel Tablolar (Many-to-Many)

CREATE TABLE HastaPsikiyatriIliskisi (
    hasta_id INT NOT NULL,
    psikiyatrist_id INT NOT NULL,
    PRIMARY KEY (hasta_id, psikiyatrist_id),
    CONSTRAINT FK_HPI_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id),
    CONSTRAINT FK_HPI_Psikiyatrist FOREIGN KEY (psikiyatrist_id) REFERENCES Psikiyatrist(psikiyatrist_id)
);

CREATE TABLE HastalikBelirtisiHastalarIliskisi (
    hasta_id INT NOT NULL,
    belirti_id INT NOT NULL,
    PRIMARY KEY (hasta_id, belirti_id),
    CONSTRAINT FK_HBHI_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id),
    CONSTRAINT FK_HBHI_HastalikBelirtileri FOREIGN KEY (belirti_id) REFERENCES HastalikBelirtileri(belirti_id)
);

CREATE TABLE HastalarTestlerIliskisi (
    hasta_id INT NOT NULL,
    test_id INT NOT NULL,
    PRIMARY KEY (hasta_id, test_id),
    CONSTRAINT FK_HTI_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id),
    CONSTRAINT FK_HTI_Testler FOREIGN KEY (test_id) REFERENCES Testler(test_id)
);

CREATE TABLE HastalarTeshisIliskisi (
    hasta_id INT NOT NULL,
    teshis_id INT NOT NULL,
    PRIMARY KEY (hasta_id, teshis_id),
    CONSTRAINT FK_HT_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id),
    CONSTRAINT FK_HT_Teshis FOREIGN KEY (teshis_id) REFERENCES Teshis(teshis_id)
);

CREATE TABLE RiskFaktorleriHastalar (
    risk_id INT NOT NULL,
    hasta_id INT NOT NULL,
    PRIMARY KEY (risk_id, hasta_id),
    CONSTRAINT FK_RF_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id),
    CONSTRAINT FK_RF_RiskFaktorleri FOREIGN KEY (risk_id) REFERENCES RiskFaktorleri(risk_id)
);

CREATE TABLE TestSonucuHastalarIliskisi (
    sonuc_id INT NOT NULL,
    hasta_id INT NOT NULL,
    PRIMARY KEY (sonuc_id, hasta_id),
    CONSTRAINT FK_TSHI_TestSonuclari FOREIGN KEY (sonuc_id) REFERENCES TestSonuclari(sonuc_id),
    CONSTRAINT FK_TSHI_Hastalar FOREIGN KEY (hasta_id) REFERENCES Hastalar(hasta_id)
);

CREATE TABLE GenelHayatRiskFaktoruIliskisi (
    hayat_id INT NOT NULL,
    risk_id INT NOT NULL,
    PRIMARY KEY (hayat_id, risk_id),
    CONSTRAINT FK_GHRF_GenelHayat FOREIGN KEY (hayat_id) REFERENCES GenelHayat(hayat_id),
    CONSTRAINT FK_GHRF_RiskFaktorleri FOREIGN KEY (risk_id) REFERENCES RiskFaktorleri(risk_id)
);

CREATE TABLE RiskFaktoruHastalikBelirtiIliskisi (
    risk_id INT NOT NULL,
    belirti_id INT NOT NULL,
    PRIMARY KEY (risk_id, belirti_id),
    CONSTRAINT FK_RFHB_RiskFaktorleri FOREIGN KEY (risk_id) REFERENCES RiskFaktorleri(risk_id),
    CONSTRAINT FK_RFHB_HastalikBelirtileri FOREIGN KEY (belirti_id) REFERENCES HastalikBelirtileri(belirti_id)
);

CREATE TABLE HastalikBelirtiTeshisIliskisi (
    belirti_id INT NOT NULL,
    teshis_id INT NOT NULL,
    PRIMARY KEY (belirti_id, teshis_id),
    CONSTRAINT FK_HBT_Teshis FOREIGN KEY (teshis_id) REFERENCES Teshis(teshis_id),
    CONSTRAINT FK_HBT_HastalikBelirtileri FOREIGN KEY (belirti_id) REFERENCES HastalikBelirtileri(belirti_id)
);

CREATE TABLE HastalikBelirtiPsikiyatriIliskisi (
    belirti_id INT NOT NULL,
    psikiyatrist_id INT NOT NULL,
    PRIMARY KEY (belirti_id, psikiyatrist_id),
    CONSTRAINT FK_HBP_Psikiyatrist FOREIGN KEY (psikiyatrist_id) REFERENCES Psikiyatrist(psikiyatrist_id),
    CONSTRAINT FK_HBP_HastalikBelirtileri FOREIGN KEY (belirti_id) REFERENCES HastalikBelirtileri(belirti_id)
);

CREATE TABLE HastalikBelirtiTedaviYontemleriIliskisi (
    belirti_id INT NOT NULL,
    yontem_id INT NOT NULL,
    PRIMARY KEY (belirti_id, yontem_id),
    CONSTRAINT FK_HBTY_TedaviYontemleri FOREIGN KEY (yontem_id) REFERENCES TedaviYontemleri(yontem_id),
    CONSTRAINT FK_HBTY_HastalikBelirtileri FOREIGN KEY (belirti_id) REFERENCES HastalikBelirtileri(belirti_id)
);

CREATE TABLE TeshisSeansIliskisi (
    teshis_id INT NOT NULL,
    seans_id INT NOT NULL,
    PRIMARY KEY (teshis_id, seans_id),
    CONSTRAINT FK_TS_Seanslar FOREIGN KEY (seans_id) REFERENCES Seanslar(seans_id),
    CONSTRAINT FK_TS_Teshis FOREIGN KEY (teshis_id) REFERENCES Teshis(teshis_id)
);

CREATE TABLE TeshisIlerlemeKayitlariIliskisi (
    teshis_id INT NOT NULL,
    kayit_id INT NOT NULL,
    PRIMARY KEY (teshis_id, kayit_id),
    CONSTRAINT FK_TIK_IlerlemeKayitlari FOREIGN KEY (kayit_id) REFERENCES IlerlemeKayitlari(kayit_id),
    CONSTRAINT FK_TIK_Teshis FOREIGN KEY (teshis_id) REFERENCES Teshis(teshis_id)
);

CREATE TABLE TeshisPsikiyatriIliskisi (
    teshis_id INT NOT NULL,
    psikiyatrist_id INT NOT NULL,
    PRIMARY KEY (teshis_id, psikiyatrist_id),
    CONSTRAINT FK_TP_Psikiyatrist FOREIGN KEY (psikiyatrist_id) REFERENCES Psikiyatrist(psikiyatrist_id),
    CONSTRAINT FK_TP_Teshis FOREIGN KEY (teshis_id) REFERENCES Teshis(teshis_id)
);

CREATE TABLE TeshisReceteIliskisi (
    teshis_id INT NOT NULL,
    recete_id INT NOT NULL,
    PRIMARY KEY (teshis_id, recete_id),
    CONSTRAINT FK_TR_Receteler FOREIGN KEY (recete_id) REFERENCES Receteler(recete_id),
    CONSTRAINT FK_TR_Teshis FOREIGN KEY (teshis_id) REFERENCES Teshis(teshis_id)
);

CREATE TABLE TeshisTedaviYontemleriIliskisi (
    teshis_id INT NOT NULL,
    yontem_id INT NOT NULL,
    PRIMARY KEY (teshis_id, yontem_id),
    CONSTRAINT FK_TTY_TedaviYontemleri FOREIGN KEY (yontem_id) REFERENCES TedaviYontemleri(yontem_id),
    CONSTRAINT FK_TTY_Teshis FOREIGN KEY (teshis_id) REFERENCES Teshis(teshis_id)
);

CREATE TABLE IlerlemeKayitlariSeansIliskisi (
    kayit_id INT NOT NULL,
    seans_id INT NOT NULL,
    PRIMARY KEY (kayit_id, seans_id),
    CONSTRAINT FK_IKSI_Seanslar FOREIGN KEY (seans_id) REFERENCES Seanslar(seans_id),
    CONSTRAINT FK_IKSI_IlerlemeKayitlari FOREIGN KEY (kayit_id) REFERENCES IlerlemeKayitlari(kayit_id)
);

CREATE TABLE IlerlemeKayitlariTestlerIliskisi (
    kayit_id INT NOT NULL,
    test_id INT NOT NULL,
    PRIMARY KEY (kayit_id, test_id),
    CONSTRAINT FK_IKTI_Testler FOREIGN KEY (test_id) REFERENCES Testler(test_id),
    CONSTRAINT FK_IKTI_IlerlemeKayitlari FOREIGN KEY (kayit_id) REFERENCES IlerlemeKayitlari(kayit_id)
);

CREATE TABLE SeansTedaviYontemleriIliskisi (
    seans_id INT NOT NULL,
    yontem_id INT NOT NULL,
    PRIMARY KEY (seans_id, yontem_id),
    CONSTRAINT FK_STY_TedaviYontemleri FOREIGN KEY (yontem_id) REFERENCES TedaviYontemleri(yontem_id),
    CONSTRAINT FK_STY_Seanslar FOREIGN KEY (seans_id) REFERENCES Seanslar(seans_id)
);

CREATE TABLE SeansReceteIliskisi (
    seans_id INT NOT NULL,
    recete_id INT NOT NULL,
    PRIMARY KEY (seans_id, recete_id),
    CONSTRAINT FK_SRI_Receteler FOREIGN KEY (recete_id) REFERENCES Receteler(recete_id),
    CONSTRAINT FK_SRI_Seanslar FOREIGN KEY (seans_id) REFERENCES Seanslar(seans_id)
);

CREATE TABLE PsikiyatriTedaviYontemleriIliskisi (
    psikiyatrist_id INT NOT NULL,
    yontem_id INT NOT NULL,
    PRIMARY KEY (psikiyatrist_id, yontem_id),
    CONSTRAINT FK_PTY_Psikiyatrist FOREIGN KEY (psikiyatrist_id) REFERENCES Psikiyatrist(psikiyatrist_id),
    CONSTRAINT FK_PTY_TedaviYontemleri FOREIGN KEY (yontem_id) REFERENCES TedaviYontemleri(yontem_id)
);

CREATE TABLE PsikiyatriTestlerIliskisi (
    psikiyatrist_id INT NOT NULL,
    test_id INT NOT NULL,
    PRIMARY KEY (psikiyatrist_id, test_id),
    CONSTRAINT FK_PTI_Psikiyatrist FOREIGN KEY (psikiyatrist_id) REFERENCES Psikiyatrist(psikiyatrist_id),
    CONSTRAINT FK_PTI_Testler FOREIGN KEY (test_id) REFERENCES Testler(test_id)
);

CREATE TABLE TedaviYontemleriRiskFaktorleriIliskisi (
    yontem_id INT NOT NULL,
    risk_id INT NOT NULL,
    PRIMARY KEY (yontem_id, risk_id),
    CONSTRAINT FK_TYRF_TedaviYontemleri FOREIGN KEY (yontem_id) REFERENCES TedaviYontemleri(yontem_id),
    CONSTRAINT FK_TYRF_RiskFaktorleri FOREIGN KEY (risk_id) REFERENCES RiskFaktorleri(risk_id)
);

CREATE TABLE TedaviYontemleriTestSonuclariIliskisi (
    yontem_id INT NOT NULL,
    sonuc_id INT NOT NULL,
    PRIMARY KEY (yontem_id, sonuc_id),
    CONSTRAINT FK_TYTS_TedaviYontemleri FOREIGN KEY (yontem_id) REFERENCES TedaviYontemleri(yontem_id),
    CONSTRAINT FK_TYTS_TestSonuclari FOREIGN KEY (sonuc_id) REFERENCES TestSonuclari(sonuc_id)
);

CREATE TABLE ReceteTestSonuclariIliskisi (
    recete_id INT NOT NULL,
    sonuc_id INT NOT NULL,
    PRIMARY KEY (recete_id, sonuc_id),
    CONSTRAINT FK_RT_Receteler FOREIGN KEY (recete_id) REFERENCES Receteler(recete_id),
    CONSTRAINT FK_RT_TestSonuclari FOREIGN KEY (sonuc_id) REFERENCES TestSonuclari(sonuc_id)
);

--- Hastalar
INSERT INTO Hastalar (hasta_id, adi, soyadi, dogum_tarihi, cinsiyet, eposta, adres, kayit_tarihi)
VALUES
(1, N'Ahmet', N'Yýlmaz', '1980-05-15', 'E', 'ahmet.yilmaz@example.com', N'Ýstanbul, Türkiye', '2025-01-10'),
(2, N'Elif', N'Demir', '1992-11-03', 'K', 'elif.demir@example.com', N'Ankara, Türkiye', '2025-02-20');


INSERT INTO HastaGecmis (gecmis_id, intihar_gecmis, alkol_kullanimi, aciklama, hasta_id)
VALUES
(1, 0, 1, N'Alkol kullanýmý orta düzeyde', 1),
(2, 1, 0, N'Ýntihar giriþimi geçmiþi var', 2);

INSERT INTO Teshis (teshis_id, aciklama)
VALUES
(1, N'Major depresyon'),
(2, N'Anksiyete bozukluðu');

INSERT INTO HastalikBelirtileri (belirti_id, belirti_adi, siddeti, baslangic_tarihi)
VALUES
(1, N'Uykusuzluk', N'Orta', '2025-01-01'),
(2, N'Ýþtahsýzlýk', N'Þiddetli', '2025-02-15');

INSERT INTO RiskFaktorleri (risk_id, faktor_tipi, aciklama, onlem_plani)
VALUES
(1, N'Genetik', N'Ailede depresyon öyküsü', N'Düzenli takip'),
(2, N'Çevresel', N'Ýþ stresi', N'Strese yönelik danýþmanlýk');

INSERT INTO IlerlemeKayitlari (kayit_id, tarihi, gelisme_durumu, olcek_skoru, hasta_id, psikiyatrist_id, tedavi_id)
VALUES
(1, '2025-04-01', N'Ýyileþme belirtileri var', 70, 1, 1, 1),
(2, '2025-05-01', N'Durum stabil', 60, 2, 2, 2);

INSERT INTO Seanslar (seans_id, tarihi, suresi, tutulan_notlar, hasta_id, psikiyatrist_id)
VALUES
(1, '2025-04-02', 60, N'Pozitif ilerleme gözlendi', 1, 1),
(2, '2025-05-03', 45, N'Kaygý seviyesi sabit', 2, 2);

INSERT INTO Receteler (recete_id, kullanim_sikligi, baslangic_tarihi, hasta_id, psikiyatrist_id, kayit_id)
VALUES
(1, N'Günde 2 kez', '2025-04-01', 1, 1, 1),
(2, N'Günde 1 kez', '2025-05-01', 2, 2, 2);

INSERT INTO TestSonuclari (sonuc_id, sonucu, yorumu, tarihi, test_id, psikiyatrist_id)
VALUES
(1, N'Anksiyete seviyesi yüksek', N'Dikkatli takip önerilir', '2025-04-10', 1, 1),
(2, N'Depresyon skoru orta', N'Tedaviye devam', '2025-05-10', 2, 2);

INSERT INTO Psikiyatrist (psikiyatrist_id, adi, soyadi, calisma_yeri)
VALUES
(1, N'Dr. Ayþe', N'Taþ', N'Ýstanbul Hastanesi'),
(2, N'Dr. Mehmet', N'Kara', N'Ankara Kliniði');

INSERT INTO TedaviYontemleri (yontem_id, turu, baslangic_tarihi, durumu, hasta_id, gecmis_id, hayat_id)
VALUES
(1, N'Biliþsel Terapi', '2025-03-01', N'Sürmekte', 1, 1, 1),
(2, N'Ýlaç Tedavisi', '2025-04-15', N'Sürmekte', 2, 2, 2);

INSERT INTO Testler (test_id, test_adi, amac)
VALUES
(1, N'Beck Anksiyete Ölçeði', N'Anksiyete seviyesini ölçmek'),
(2, N'Hamilton Depresyon Ölçeði', N'Depresyon þiddetini deðerlendirmek');

INSERT INTO HastaPsikiyatriIliskisi (hasta_id, psikiyatrist_id) VALUES (1,1), (2,2);

INSERT INTO HastalikBelirtisiHastalarIliskisi (hasta_id, belirti_id) VALUES (1,1), (2,2);

INSERT INTO HastalarTestlerIliskisi (hasta_id, test_id) VALUES (1,1), (2,2);

INSERT INTO HastalarTeshisIliskisi (hasta_id, teshis_id) VALUES (1,1), (2,2);

INSERT INTO RiskFaktorleriHastalar (risk_id, hasta_id) VALUES (1,1), (2,2);

INSERT INTO TestSonucuHastalarIliskisi (sonuc_id, hasta_id) VALUES (1,1), (2,2);

INSERT INTO GenelHayatRiskFaktoruIliskisi (hayat_id, risk_id) VALUES (1,1), (2,2);

INSERT INTO RiskFaktoruHastalikBelirtiIliskisi (risk_id, belirti_id) VALUES (1,1), (2,2);

INSERT INTO HastalikBelirtiTeshisIliskisi (belirti_id, teshis_id) VALUES (1,1), (2,2);

INSERT INTO HastalikBelirtiPsikiyatriIliskisi (belirti_id, psikiyatrist_id) VALUES (1,1), (2,2);

INSERT INTO HastalikBelirtiTedaviYontemleriIliskisi (belirti_id, yontem_id) VALUES (1,1), (2,2);

INSERT INTO TeshisSeansIliskisi (teshis_id, seans_id) VALUES (1,1), (2,2);

INSERT INTO TeshisIlerlemeKayitlariIliskisi (teshis_id, kayit_id) VALUES (1,1), (2,2);

INSERT INTO TeshisPsikiyatriIliskisi (teshis_id, psikiyatrist_id) VALUES (1,1), (2,2);

INSERT INTO TeshisReceteIliskisi (teshis_id, recete_id) VALUES (1,1), (2,2);

INSERT INTO TeshisTedaviYontemleriIliskisi (teshis_id, yontem_id) VALUES (1,1), (2,2);

INSERT INTO IlerlemeKayitlariSeansIliskisi (kayit_id, seans_id) VALUES (1,1), (2,2);

INSERT INTO IlerlemeKayitlariTestlerIliskisi (kayit_id, test_id) VALUES (1,1), (2,2);

INSERT INTO SeansTedaviYontemleriIliskisi (seans_id, yontem_id) VALUES (1,1), (2,2);

INSERT INTO SeansReceteIliskisi (seans_id, recete_id) VALUES (1,1), (2,2);

INSERT INTO PsikiyatriTedaviYontemleriIliskisi (psikiyatrist_id, yontem_id) VALUES (1,1), (2,2);

INSERT INTO PsikiyatriTestlerIliskisi (psikiyatrist_id, test_id) VALUES (1,1), (2,2);

INSERT INTO TedaviYontemleriRiskFaktorleriIliskisi (yontem_id, risk_id) VALUES (1,1), (2,2);

INSERT INTO TedaviYontemleriTestSonuclariIliskisi (yontem_id, sonuc_id) VALUES (1,1), (2,2);

INSERT INTO ReceteTestSonuclariIliskisi (recete_id, sonuc_id) VALUES (1,1), (2,2);