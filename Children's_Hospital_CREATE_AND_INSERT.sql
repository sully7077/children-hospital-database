REM   Script: INFO 605 Project v1 Loaded w/Fake Data
REM   Tables are created, and fake data has been entered. 

CREATE TABLE InsuranceProvider 
( 
insurerID				VARCHAR2(4) NOT NULL PRIMARY KEY, 
insurerName				VARCHAR2(20) NOT NULL UNIQUE, 
companyPhoneAC			CHAR(3), 
companyPhone			CHAR(7),  
companyContactEmail		VARCHAR2(20), 
companyFax				CHAR(10), 
companyStreet			VARCHAR2(30), 
companyCity				VARCHAR2(15), 
companyState			CHAR(2), 
companyZip				CHAR(5) 
);

CREATE TABLE Residence 
( 
addressID				VARCHAR2(6) NOT NULL PRIMARY KEY, 
streetAddress			VARCHAR2(30), 
cityAddress				VARCHAR2(15), 
stateAddress			CHAR(2), 
zipAddress				CHAR(5), 
residenceType			VARCHAR2(10) CHECK (residenceType IN('permanent', 'temporary', 'transient')) 
);

CREATE TABLE Allergy 
( 
allergyName				VARCHAR2(20) NOT NULL PRIMARY KEY, 
allergyType				VARCHAR2(20), 
allergyAlert			VARCHAR2(40) 
);

CREATE TABLE ChronicCondition 
( 
conditionName				VARCHAR2(20) NOT NULL PRIMARY KEY,	 
conditionDescription		VARCHAR2(60), 
conditionDrugInteraction	VARCHAR2(30), 
conditionSurgeryAlert		VARCHAR2(60) 
);

CREATE TABLE ServiceListing 
( 
serviceID				VARCHAR2(6) NOT NULL PRIMARY KEY, 
serviceDescription		VARCHAR2(40), 
serviceCost				NUMBER(7, 2) NOT NULL, 
amaCode					VARCHAR2(3) UNIQUE, 
hcpCode					VARCHAR2(3) UNIQUE 
);

CREATE TABLE Equipment  
(  
equipmentID					VARCHAR2(10) NOT NULL PRIMARY KEY,  
reorderNumber				VARCHAR2(5),  
acquiredDate				DATE,  
modelNumber					VARCHAR2(5),  
warrantyExpirationDate		DATE,  
status						VARCHAR2(11) CHECK (status IN('service', 'maintenance', 'repair', 'storage', 'disposed')),  
serviceInterval				NUMBER(4),  
lastServicedDate			DATE  
);

CREATE TABLE PaymentMedium 
( 
paymentID				VARCHAR2(12) NOT NULL PRIMARY KEY, 
paymentAmount			NUMBER(8, 2), 
paymentDate				DATE, 
paymentSource			CHAR(1) CHECK (paymentSource IN('g', 'i', 'c', 'o')) 
);

CREATE TABLE Patient 
( 
patientID				VARCHAR2(10) NOT NULL PRIMARY KEY, 
patientFirstName		VARCHAR2(20), 
patientLastName			VARCHAR2(20), 
patientDOB				DATE, 
patientSSN				CHAR(9) NOT NULL UNIQUE, 
addressID				VARCHAR2(6), 
CONSTRAINT Patient_FK1 FOREIGN KEY (addressID) REFERENCES Residence(addressID) 
);

CREATE TABLE Guardian 
( 
guardianID				VARCHAR2(10) NOT NULL PRIMARY KEY, 
relationshipType		VARCHAR2(15), 
contactPhoneAC			CHAR(3), 
contactPhoneNumber		VARCHAR2(10), 
contactEmailAddress		VARCHAR2(20), 
contactHourStart		CHAR(5), 
contactHourEnd			CHAR(5), 
guardianFirstName		VARCHAR2(20), 
guardianLastName		VARCHAR2(20), 
addressID				VARCHAR2(6), 
CONSTRAINT Guardian_FK1 FOREIGN KEY (addressID) REFERENCES Residence(addressID) 
);

CREATE TABLE HealthInsurancePolicy 
( 
hiPayerID				VARCHAR2(12) NOT NULL, 
memberID				VARCHAR2(10) NOT NULL UNIQUE, 
groupNumber				VARCHAR2(9), 
planName				VARCHAR2(15), 
policyExpirationDate	DATE, 
insurerID				VARCHAR2(4), 
CONSTRAINT HealthInsurancePolicy_PK PRIMARY KEY (hiPayerID), 
CONSTRAINT HealthInsurancePolicy_FK1 FOREIGN KEY (hiPayerID) REFERENCES PaymentMedium(paymentID), 
CONSTRAINT HealthInsurancePolicy_FK2 FOREIGN KEY (insurerID) REFERENCES InsuranceProvider(insurerID) 
);

CREATE TABLE CharitableOrganization 
( 
organizationPID			VARCHAR2(12) NOT NULL, 
organizationName		VARCHAR2(20) UNIQUE, 
organizationPhone		CHAR(10), 
organizationEmail		VARCHAR2(20), 
oStreetAddress			VARCHAR2(30), 
oCityAddress			VARCHAR2(15), 
oStateAddress			CHAR(2), 
oZipAddress				CHAR(5), 
CONSTRAINT CharitableOrganization_PK1 PRIMARY KEY (organizationPID), 
CONSTRAINT CharitableOrganization_FK1 FOREIGN KEY (organizationPID) REFERENCES PaymentMedium(paymentID) 
);

CREATE TABLE GuardianPayment 
( 
gPaymentID				VARCHAR2(12) NOT NULL, 
cardNumber				VARCHAR2(20), 
checkNumber				VARCHAR2(20), 
guardianID				VARCHAR2(10), 
CONSTRAINT GuardianPayment_PK PRIMARY KEY (gPaymentID), 
CONSTRAINT GuardianPayment_FK1 FOREIGN KEY (gPaymentID) REFERENCES PaymentMedium(paymentID), 
CONSTRAINT GuardianPayment_FK2 FOREIGN KEY (guardianID) REFERENCES Guardian(guardianID) 
);

CREATE TABLE Payment 
( 
receiptID				VARCHAR2(16) NOT NULL PRIMARY KEY, 
amountPaid				NUMBER(8, 2), 
paymentType				VARCHAR2(10) CHECK (paymentType IN('check', 'cash', 'credit', 'transfer', 'debit')), 
paymentDetails			VARCHAR2(30), 
paymentID				VARCHAR2(12), 
patientID				VARCHAR2(10), 
CONSTRAINT Payment_FK1 FOREIGN KEY (paymentID) REFERENCES PaymentMedium(paymentID), 
CONSTRAINT Payment_FK2 FOREIGN KEY (patientID) REFERENCES Patient(patientID) 
);

CREATE TABLE Guardianship 
( 
patientID				VARCHAR2(10) NOT NULL, 
guardianID				VARCHAR2(10) NOT NULL, 
CONSTRAINT Guardianship_PK PRIMARY KEY (patientID, guardianID), 
CONSTRAINT Guardianship_FK1 FOREIGN KEY (patientID) REFERENCES Patient(patientID), 
CONSTRAINT Guardianship_FK2 FOREIGN KEY (guardianID) REFERENCES Guardian(guardianID) 
);

CREATE TABLE PatientAllergy 
( 
patientID				VARCHAR2(10) NOT NULL, 
allergyName				VARCHAR2(20) NOT NULL, 
aSeverity				VARCHAR2(20) CHECK (aSeverity IN('undetectable', 'mild', 'moderate', 'severe', 'life-threatening')), 
reaction				VARCHAR2(25), 
CONSTRAINT PatientAllergy_PK PRIMARY KEY (patientID, allergyName), 
CONSTRAINT PatientAllergy_FK1 FOREIGN KEY (patientID) REFERENCES Patient(patientID), 
CONSTRAINT PatientAllergy_FK2 FOREIGN KEY (allergyName) REFERENCES Allergy(allergyName) 
);

CREATE TABLE PatientCondition 
( 
patientID				VARCHAR2(10) NOT NULL, 
conditionName			VARCHAR2(20) NOT NULL, 
cSeverity				VARCHAR2(20) CHECK (cSeverity IN('undetectable', 'mild', 'moderate', 'severe', 'life-threatening')), 
diagnosisDate			DATE, 
conditionNote			VARCHAR2(50), 
CONSTRAINT PatientCondition_PK PRIMARY KEY (patientID, conditionName), 
CONSTRAINT PatientCondition_FK1 FOREIGN KEY (patientID) REFERENCES Patient(patientID), 
CONSTRAINT PatientCondition_FK2 FOREIGN KEY (conditionName) REFERENCES ChronicCondition(conditionName) 
);

CREATE TABLE PatientVisit 
( 
visitID					VARCHAR2(16) NOT NULL PRIMARY KEY, 
dateofVisit				DATE, 
chiefComplaint			VARCHAR2(40), 
visitNotes				VARCHAR2(80), 
patientID				VARCHAR2(10), 
CONSTRAINT PatientVisit_FK1 FOREIGN KEY (patientID) REFERENCES Patient(patientID) 
);

CREATE TABLE PastSurgery 
( 
surgeryID				VARCHAR2(12) NOT NULL PRIMARY KEY, 
surgeryName				VARCHAR2(30), 
surgeryDate				DATE, 
surgeryNote				VARCHAR2(80), 
surgeonName				VARCHAR2(40), 
surgeonPhone			VARCHAR2(15), 
patientID				VARCHAR2(10), 
CONSTRAINT PastSurgery_FK1 FOREIGN KEY (patientID) REFERENCES Patient(patientID) 
);

CREATE TABLE EquipmentUsed 
( 
equipmentID				VARCHAR2(10) NOT NULL, 
visitID					VARCHAR2(16) NOT NULL, 
CONSTRAINT EquipmentUsed_PK PRIMARY KEY (equipmentID, visitID), 
CONSTRAINT EquipmentUsed_FK1 FOREIGN KEY (equipmentID) REFERENCES Equipment(equipmentID), 
CONSTRAINT EquipmentUsed_FK2 FOREIGN KEY (visitID) REFERENCES PatientVisit(visitID) 
);

CREATE TABLE FutureAppointment 
( 
appointmentID			VARCHAR2(16) NOT NULL PRIMARY KEY, 
appointmentDT			DATE NOT NULL, 
anticipatedService		VARCHAR2(40), 
visitID					VARCHAR2(16), 
CONSTRAINT FutureAppointment_FK1 FOREIGN KEY (visitID) REFERENCES PatientVisit(visitID) 
);

CREATE TABLE ServiceAtVisit 
( 
visitID					VARCHAR2(16) NOT NULL, 
serviceID				VARCHAR2(6) NOT NULL, 
numberUsed				NUMBER(3), 
serviceCost				NUMBER(8, 2), 
CONSTRAINT ServiceAtVisit_PK PRIMARY KEY (visitID, serviceID), 
CONSTRAINT ServiceAtVisit_FK1 FOREIGN KEY (visitID) REFERENCES PatientVisit(visitID), 
CONSTRAINT ServiceAtVisit_FK2 FOREIGN KEY (serviceID) REFERENCES ServiceListing(serviceID) 
);

INSERT INTO INSURANCEPROVIDER VALUES ('581', 'Dooley and Abernathy', '504', '5967107', 'mspadoll@comcast.net', '3035726503', '381 Di Loreto Park', 'New Orleans', 'LA', '61263');

INSERT INTO INSURANCEPROVIDER VALUES ('14', 'Sporer-Kling', '937', '7909537', 'mbuts1@woothemes.com', '2124419478', '166 Lawn Pass', 'Dayton', 'OH', '12829');

INSERT INTO INSURANCEPROVIDER VALUES ('93', 'Little and Sporer', '630', '3084491', 'rrosenblad2@sina.com', '6023244306', '87 Fisk Park', 'Naperville', 'IL', '12077');

INSERT INTO INSURANCEPROVIDER VALUES ('319', 'Fadel Blick', '804', '8576286', 'rtuns@indiatimes.com', '4804453672', '66 Farwell Park', 'Richmond', 'VA', '16518');

INSERT INTO INSURANCEPROVIDER VALUES ('170', 'Reillyand Hermiston', '305', '5759900', 'cvalois4@xing.com', '2144133621', '99307 5th Trail', 'Miami', 'FL', '34200');

INSERT INTO INSURANCEPROVIDER VALUES ('552', 'Mitchell Group', '432', '9859816', 'rdoulden5@umn.edu', '9155501971', '97137 Dapin Way', 'Midland', 'TX', '15769');

INSERT INTO INSURANCEPROVIDER VALUES ('258', 'Mraz and Mayer', '415', '1678221', 'dmuff6@about.com', '5174051012', '92848 Jay Junction', 'Oakland', 'CA', '78977');

INSERT INTO INSURANCEPROVIDER VALUES ('241', 'Deckow and Kemmer', '972', '1771364', 'tbowhay7@buzz.com', '7167013061', '20 Forest Run Terrace', 'Dallas', 'TX', '35534');

INSERT INTO INSURANCEPROVIDER VALUES ('21', 'Lockman LLC', '478', '2894399', 'avellden8@gov.uk', '5054339964', '25 Carberry Avenue', 'Macon', 'GA', '17979');

INSERT INTO INSURANCEPROVIDER VALUES ('504', 'Mante-Sporer', '360', '1006713', 'gpeyton9@prlog.org', '9705912085', '21233 Sunbrook Park', 'Vancouver', 'WA', '97103');

INSERT INTO INSURANCEPROVIDER VALUES ('496', 'Lakin Group', '610', '9190574', 'cghion@hostgator.com', '6159777886', '57 Warbler Hill', 'Reading', 'PA', '57609');

INSERT INTO INSURANCEPROVIDER VALUES ('207', 'Weber Inc', '727', '6502472', 'mtschurschb@home.com', '4696481266', '23 Anthes Drive', 'Clearwater', 'FL', '15963');

INSERT INTO INSURANCEPROVIDER VALUES ('318', 'Goldner-Thompson', '941', '4606662', 'rdobbinsonc@eco.com', '5131223752', '95967 Ilene Terrace', 'Port Charlotte', 'FL', '13142');

INSERT INTO INSURANCEPROVIDER VALUES ('267', 'Kertzmann and Sons', '757', '4193780', 'docuola@mozilla.com', '6121981563', '7204 Evergreen Hill', 'Portsmouth', 'VA', '38848');

INSERT INTO INSURANCEPROVIDER VALUES ('144', 'Jenkins-Rempel', '330', '5140126', 'dbilbe@ustream.tv', '734995107', '241 Arizona Parkway', 'Akron', 'OH', '13946');

INSERT INTO INSURANCEPROVIDER VALUES ('145', 'Jerde and Beatty', '817', '1315678', 'gspa@vkontakte.ru', '7861381748', '12438 Stone Corner Center', 'Fort Worth', 'TX', '66501');

INSERT INTO INSURANCEPROVIDER VALUES ('572', 'Koch and Flatley', '313', '5743972', 'dbrissard@barnes.com', '3611031351', '6596 Esker Trail', 'Detroit', 'MI', '22344');

INSERT INTO INSURANCEPROVIDER VALUES ('558', 'Senger Watsica', '210', '8789568', 'cdoryh@miibeian.gov', '2023084332', '93 Kings Road', 'San Antonio', 'TX', '87769');

INSERT INTO INSURANCEPROVIDER VALUES ('10', 'Botsford and Roob', '540', '6382427', 'mvillaltai@squid.com', '7346726354', '83 Waubesa Trail', 'Roanoke', 'VA', '66713');

INSERT INTO INSURANCEPROVIDER VALUES ('700', 'Beierand Litle', '803', '4778145', 'jknappj@edublogs.org', '9713973777', '81039 Weeping Birch Alley', 'Columbia', 'SC', '48889');

INSERT INTO RESIDENCE VALUES ('244', '209 Almo Parkway', 'Pasadena', 'CA', '19930', 'permanent');

INSERT INTO RESIDENCE VALUES ('402', '53 Fairfield Trail', 'Irvine', 'CA', '16124', 'temporary');

INSERT INTO RESIDENCE VALUES ('191', '9 Texas Point', 'Las Vegas', 'NV', '34478', 'transient');

INSERT INTO RESIDENCE VALUES ('234', '200 West Hill', 'San Francisco', 'CA', '60321', 'permanent');

INSERT INTO RESIDENCE VALUES ('390', '164 Roth Court', 'Santa Barbara', 'CA', '18542', 'temporary');

INSERT INTO RESIDENCE VALUES ('359', '29087 Eggendart Circle', 'Boise', 'ID', '18230', 'transient');

INSERT INTO RESIDENCE VALUES ('113', '371 American Parkway', 'Madison', 'WI', '66518', 'permanent');

INSERT INTO RESIDENCE VALUES ('497', '2790 Schmedeman Hill', 'Salt Lake City', 'UT', '25867', 'temporary');

INSERT INTO RESIDENCE VALUES ('500', '3700 Merchant Point', 'Roanoke', 'VA', '17633', 'transient');

INSERT INTO RESIDENCE VALUES ('182', '572 Ruskin Trail', 'Philadelphia', 'PA', '91711', 'permanent');

INSERT INTO RESIDENCE VALUES ('440', '14 Heffernan Lane', 'Honolulu', 'HI', '53080', 'temporary');

INSERT INTO RESIDENCE VALUES ('170', '39873 Homewood Crossing', 'Minneapolis', 'MN', '70075', 'transient');

INSERT INTO RESIDENCE VALUES ('334', '22789 Laurel Plaza', 'Oklahoma City', 'OK', '40817', 'permanent');

INSERT INTO RESIDENCE VALUES ('494', '06055 Village Avenue', 'Pittsburgh', 'PA', '52700', 'temporary');

INSERT INTO RESIDENCE VALUES ('478', '483 Hauk Circle', 'Austin', 'TX', '51302', 'transient');

INSERT INTO RESIDENCE VALUES ('351', '6 Sloan Road', 'San Antonio', 'TX', '97261', 'permanent');

INSERT INTO RESIDENCE VALUES ('195', '9 Sommers Lane', 'Atlanta', 'GA', '71458', 'permanent');

INSERT INTO RESIDENCE VALUES ('501', '25 Park Meadow Street', 'Charlotte', 'NC', '88162', 'permanent');

INSERT INTO RESIDENCE VALUES ('251', '5495 Charing Cross Place', 'Phoenix', 'AZ', '10817', 'permanent');

INSERT INTO RESIDENCE VALUES ('256', '726 Morrow Way', 'Baltimore', 'MD', '18867', 'permanent');

INSERT INTO RESIDENCE VALUES ('432', '3 Granby Park', 'Memphis', 'TN', '46687', 'permanent');

INSERT INTO RESIDENCE VALUES ('502', '4856 Tony Crossing', 'Indianapolis', 'IN', '95910', 'permanent');

INSERT INTO RESIDENCE VALUES ('419', '41 Weeping Birch Place', 'Washington', 'DC', '80373', 'permanent');

INSERT INTO RESIDENCE VALUES ('339', '4736 Chinook Junction', 'Philadelphia', 'PA', '83106', 'permanent');

INSERT INTO RESIDENCE VALUES ('443', '8960 Maple Wood Pass', 'San Francisco', 'CA', '96998', 'permanent');

INSERT INTO RESIDENCE VALUES ('503', '086 Sage Avenue', 'Atlanta', 'GA', '83418', 'permanent');

INSERT INTO RESIDENCE VALUES ('127', '6279 Manitowish Avenue', 'Boise', 'ID', '39208', 'permanent');

INSERT INTO RESIDENCE VALUES ('480', '258 Messerschmidt Crossing', 'Laredo', 'TX', '14194', 'permanent');

INSERT INTO RESIDENCE VALUES ('377', '96 Caliangt Crossing', 'Kansas City', 'MO', '75836', 'permanent');

INSERT INTO RESIDENCE VALUES ('201', '184 Jenna Place', 'Evanston', 'IL', '57288', 'permanent');

INSERT INTO RESIDENCE VALUES ('108', '18446 Hovde Terrace', 'Harrisburg', 'PA', '44768', 'permanent');

INSERT INTO RESIDENCE VALUES ('183', '3 Hayes Park', 'Fort Collins', 'CO', '39602', 'permanent');

INSERT INTO RESIDENCE VALUES ('474', '589 Sycamore Road', 'Brooklyn', 'NY', '45021', 'permanent');

INSERT INTO RESIDENCE VALUES ('482', '55 Iowa Place', 'Elizabeth', 'NJ', '20254', 'permanent');

INSERT INTO RESIDENCE VALUES ('504', '4 Leroy Place', 'Pasadena', 'TX', '32826', 'permanent');

INSERT INTO RESIDENCE VALUES ('206', '4 Kings Pass', 'San Antonio', 'TX', '89904', 'permanent');

INSERT INTO RESIDENCE VALUES ('187', '10044 Susan Trail', 'Lincoln', 'NE', '30030', 'permanent');

INSERT INTO RESIDENCE VALUES ('204', '093 Rockefeller Point', 'Des Moines', 'IA', '60479', 'permanent');

INSERT INTO RESIDENCE VALUES ('271', '28 Heffernan Trail', 'Saginaw', 'MI', '71568', 'permanent');

INSERT INTO RESIDENCE VALUES ('188', '1703 Waubesa Parkway', 'Hialeah', 'FL', '77772', 'permanent');

INSERT INTO RESIDENCE VALUES ('166', '509 Monument Hill', 'Dayton', 'OH', '35133', 'permanent');

INSERT INTO RESIDENCE VALUES ('133', '420 Mitchell Point', 'Amarillo', 'TX', '19559', 'permanent');

INSERT INTO RESIDENCE VALUES ('120', '5 Westerfield Place', 'Boulder', 'CO', '17078', 'permanent');

INSERT INTO RESIDENCE VALUES ('205', '52 Mandrake Lane', 'New York City', 'NY', '63061', 'permanent');

INSERT INTO RESIDENCE VALUES ('386', '639 Porter Parkway', 'Newark', 'NJ', '43742', 'permanent');

INSERT INTO RESIDENCE VALUES ('267', '44 Dahle Crossing', 'Ann Arbor', 'MI', '35266', 'permanent');

INSERT INTO RESIDENCE VALUES ('309', '40216 4th Hill', 'Saint Paul', 'MN', '94337', 'permanent');

INSERT INTO RESIDENCE VALUES ('258', '8 Kim Road', 'Pittsburgh', 'PA', '71181', 'permanent');

INSERT INTO RESIDENCE VALUES ('353', '5 Sloan Court', 'Fort Lauderdale', 'FL', '48276', 'permanent');

INSERT INTO RESIDENCE VALUES ('233', '5118 Fairfield Lane', 'Fort Lauderdale', 'FL', '76170', 'permanent');

INSERT INTO RESIDENCE VALUES ('200', '2 Park Meadow Way', 'Santa Barbara', 'CA', '73848', 'transient');

INSERT INTO RESIDENCE VALUES ('407', '19475 Kennedy Alley', 'Cape Coral', 'FL', '44931', 'permanent');

INSERT INTO RESIDENCE VALUES ('350', '2726 Milwaukee Drive', 'Tampa', 'FL', '23494', 'temporary');

INSERT INTO RESIDENCE VALUES ('288', '18485 Bartillon Point', 'Kissimmee', 'FL', '21263', 'transient');

INSERT INTO RESIDENCE VALUES ('438', '59802 Granby Parkway', 'South Bend', 'IN', '83472', 'permanent');

INSERT INTO RESIDENCE VALUES ('442', '37533 Forest Center', 'Jacksonville', 'FL', '10345', 'temporary');

INSERT INTO RESIDENCE VALUES ('383', '7 Cardinal Pass', 'Orlando', 'FL', '60521', 'transient');

INSERT INTO RESIDENCE VALUES ('104', '965 Carey Place', 'Grand Rapids', 'MI', '69425', 'temporary');

INSERT INTO RESIDENCE VALUES ('388', '7755 Moose Crossing', 'Houston', 'TX', '40462', 'transient');

INSERT INTO ALLERGY VALUES ('Food', 'A', 'peanuts');

INSERT INTO ALLERGY VALUES ('Drug', 'A', 'asprin');

INSERT INTO ALLERGY VALUES ('Insect', 'C', 'bee');

INSERT INTO ALLERGY VALUES ('Pet', 'C', 'cat');

INSERT INTO ALLERGY VALUES ('Mold', 'B', 'black');

INSERT INTO ALLERGY VALUES ('Pollen', 'B', 'sunflower');

INSERT INTO ALLERGY VALUES ('Latex', 'D', 'powdered');

INSERT INTO CHRONICCONDITION VALUES ('Respiratory Infec', 'Can impact a throat, sinuses, lungs and airways.', 'Ibuprofen', 'Extra supplies');

INSERT INTO CHRONICCONDITION VALUES ('High Cholesterol', 'Cholesterol reading is 200 mg/dL or higher.', 'Ethinyl Estradiol', 'Extra supplies');

INSERT INTO CHRONICCONDITION VALUES ('Hypertension', 'Blood pressure readings of a number at or higher than 130/80', 'Lisinopril', 'Pre-op treatment');

INSERT INTO CHRONICCONDITION VALUES ('Type 2 Diabetes', 'Characterized by high blood sugar levels and insulin', 'Chlorpheniramine Maleate', 'Trans-op notice');

INSERT INTO CHRONICCONDITION VALUES ('COPD', 'Impact the ability to breathe properly', 'morphine sulfate', 'Allergies');

INSERT INTO CHRONICCONDITION VALUES ('Acid reflux', 'Include problems with the esophagus and stomach lining.', 'pancrelipase', 'Medication pre');

INSERT INTO CHRONICCONDITION VALUES ('Cancer', 'Converting sugar into adnormal cell growth.', 'Betaxolol', 'Post-op recovery');

INSERT INTO SERVICELISTING VALUES ('756', 'Operation', '35201.77', '644', '423');

INSERT INTO SERVICELISTING VALUES ('648', 'Supplies', '4626.41', '695', '570');

INSERT INTO SERVICELISTING VALUES ('684', 'Medicine', '25947.91', '705', '861');

INSERT INTO SERVICELISTING VALUES ('546', 'Operation', '46489.19', '416', '441');

INSERT INTO SERVICELISTING VALUES ('442', 'Supplies', '40086.98', '564', '900');

INSERT INTO SERVICELISTING VALUES ('778', 'Medicine', '31608.83', '649', '400');

INSERT INTO SERVICELISTING VALUES ('664', 'Operation', '4269.75', '901', '579');

INSERT INTO SERVICELISTING VALUES ('878', 'Supplies', '10878.46', '807', '775');

INSERT INTO SERVICELISTING VALUES ('860', 'Medicine', '7473.65', '824', '631');

INSERT INTO SERVICELISTING VALUES ('819', 'Operation', '11310.38', '664', '640');

INSERT INTO SERVICELISTING VALUES ('508', 'Supplies', '3853.27', '758', '451');

INSERT INTO SERVICELISTING VALUES ('490', 'Medicine', '36690.12', '477', '419');

INSERT INTO SERVICELISTING VALUES ('463', 'Operation', '46135.59', '732', '783');

INSERT INTO SERVICELISTING VALUES ('680', 'Supplies', '6187.23', '502', '425');

INSERT INTO SERVICELISTING VALUES ('548', 'Medicine', '28850.49', '842', '721');

INSERT INTO SERVICELISTING VALUES ('503', 'Operation', '3723.53', '780', '458');

INSERT INTO SERVICELISTING VALUES ('462', 'Supplies', '47147.81', '902', '692');

INSERT INTO SERVICELISTING VALUES ('488', 'Medicine', '44687.68', '763', '654');

INSERT INTO SERVICELISTING VALUES ('886', 'Operation', '13016.28', '691', '444');

INSERT INTO SERVICELISTING VALUES ('853', 'Supplies', '39739.23', '641', '482');

INSERT INTO SERVICELISTING VALUES ('495', 'Medicine', '24123.87', '884', '572');

INSERT INTO SERVICELISTING VALUES ('444', 'Operation', '35567.39', '627', '903');

INSERT INTO SERVICELISTING VALUES ('600', 'Supplies', '47782.82', '712', '550');

INSERT INTO SERVICELISTING VALUES ('513', 'Medicine', '36795.53', '553', '636');

INSERT INTO SERVICELISTING VALUES ('837', 'Operation', '34678.85', '568', '497');

INSERT INTO SERVICELISTING VALUES ('500', 'Supplies', '21015.7', '855', '904');

INSERT INTO SERVICELISTING VALUES ('550', 'Medicine', '39483.13', '766', '832');

INSERT INTO SERVICELISTING VALUES ('458', 'Operation', '10896.13', '635', '534');

INSERT INTO SERVICELISTING VALUES ('821', 'Supplies', '22529.97', '876', '905');

INSERT INTO SERVICELISTING VALUES ('825', 'Medicine', '20667.18', '891', '604');

INSERT INTO SERVICELISTING VALUES ('714', 'Operation', '49001.26', '596', '529');

INSERT INTO SERVICELISTING VALUES ('617', 'Supplies', '41719.39', '724', '768');

INSERT INTO SERVICELISTING VALUES ('515', 'Medicine', '45284.97', '754', '430');

INSERT INTO SERVICELISTING VALUES ('519', 'Operation', '23022.57', '895', '864');

INSERT INTO SERVICELISTING VALUES ('618', 'Supplies', '35493.35', '496', '796');

INSERT INTO SERVICELISTING VALUES ('688', 'Medicine', '43930.69', '405', '614');

INSERT INTO SERVICELISTING VALUES ('806', 'Operation', '18897.48', '686', '672');

INSERT INTO SERVICELISTING VALUES ('720', 'Supplies', '42163.37', '514', '756');

INSERT INTO EQUIPMENT VALUES ('1', '505', '12-Nov-1992', '33920', '19-Jul-1993', 'service', '0', '4-Jul-1994');

INSERT INTO EQUIPMENT VALUES ('2', '298', '25-Jan-1989', '32533', '4-Dec-2010', 'maintenance', '3', '19-Nov-2011');

INSERT INTO EQUIPMENT VALUES ('3', '454', '8-Aug-1984', '30902', '16-Mar-2018', 'repair', '3', '1-Mar-2019');

INSERT INTO EQUIPMENT VALUES ('4', '408', '24-Jun-2008', '39623', '5-May-2024', 'storage', '4', '20-Apr-2025');

INSERT INTO EQUIPMENT VALUES ('5', '564', '16-Apr-2005', '38458', '12-Apr-2026', 'disposed', '1', '28-Mar-2027');

INSERT INTO EQUIPMENT VALUES ('6', '540', '8-Oct-2004', '38268', '29-Dec-2010', 'service', '2', '14-Dec-2011');

INSERT INTO EQUIPMENT VALUES ('7', '265', '8-Mar-1981', '29653', '3-Nov-1995', 'maintenance', '2', '18-Oct-1996');

INSERT INTO EQUIPMENT VALUES ('8', '353', '9-Aug-1999', '36381', '9-Jul-2019', 'repair', '0', '23-Jun-2020');

INSERT INTO EQUIPMENT VALUES ('9', '565', '27-Feb-2006', '38775', '4-Dec-2009', 'storage', '4', '19-Nov-2010');

INSERT INTO EQUIPMENT VALUES ('10', '44', '18-May-1990', '33011', '13-Sep-1999', 'disposed', '1', '28-Aug-2000');

INSERT INTO EQUIPMENT VALUES ('11', '384', '15-Oct-2017', '43023', '18-Jul-2030', 'service', '2', '3-Jul-2031');

INSERT INTO EQUIPMENT VALUES ('12', '293', '8-Mar-2006', '38784', '13-Feb-2021', 'maintenance', '4', '29-Jan-2022');

INSERT INTO EQUIPMENT VALUES ('13', '478', '7-Sep-2002', '37506', '28-Mar-2003', 'repair', '2', '12-Mar-2004');

INSERT INTO EQUIPMENT VALUES ('14', '334', '28-Feb-1993', '34028', '10-Oct-2003', 'storage', '4', '24-Sep-2004');

INSERT INTO EQUIPMENT VALUES ('15', '504', '30-Mar-2010', '40267', '19-Jun-2021', 'service', '2', '4-Jun-2022');

INSERT INTO EQUIPMENT VALUES ('16', '107', '29-May-2017', '42884', '2-Jul-2040', 'maintenance', '4', '17-Jun-2041');

INSERT INTO EQUIPMENT VALUES ('17', '197', '13-Jul-1993', '34163', '31-Dec-2006', 'repair', '2', '16-Dec-2007');

INSERT INTO EQUIPMENT VALUES ('18', '403', '21-Sep-2016', '42634', '20-May-2021', 'service', '4', '5-May-2022');

INSERT INTO EQUIPMENT VALUES ('19', '121', '24-Dec-1997', '35788', '20-Aug-2021', 'maintenance', '2', '5-Aug-2022');

INSERT INTO EQUIPMENT VALUES ('20', '39', '17-Apr-2023', '45033', '2-Aug-2070', 'service', '1', '18-Jul-2071');

INSERT INTO EQUIPMENT VALUES ('21', '379', '20-Mar-2011', '40622', '28-Dec-2045', 'service', '2', '13-Dec-2046');

INSERT INTO EQUIPMENT VALUES ('22', '259', '15-Jul-1992', '33800', '2-Dec-2023', 'service', '2', '16-Nov-2024');

INSERT INTO EQUIPMENT VALUES ('23', '172', '12-Feb-1995', '34742', '29-Nov-2003', 'service', '0', '13-Nov-2004');

INSERT INTO EQUIPMENT VALUES ('24', '365', '26-Jul-2015', '42211', '3-Dec-2020', 'service', '4', '18-Nov-2021');

INSERT INTO EQUIPMENT VALUES ('25', '132', '25-Aug-1993', '34206', '20-Sep-1996', 'service', '1', '5-Sep-1997');

INSERT INTO EQUIPMENT VALUES ('26', '76', '14-Nov-2016', '42688', '8-Jun-2034', 'service', '2', '24-May-2035');

INSERT INTO EQUIPMENT VALUES ('27', '294', '14-Feb-1981', '29631', '9-Mar-2022', 'service', '1', '22-Feb-2023');

INSERT INTO EQUIPMENT VALUES ('28', '295', '12-Sep-1983', '30571', '3-Jun-2003', 'service', '4', '18-May-2004');

INSERT INTO EQUIPMENT VALUES ('29', '304', '26-Dec-2005', '38712', '17-Jan-2010', 'service', '4', '2-Jan-2011');

INSERT INTO EQUIPMENT VALUES ('30', '439', '28-Aug-2003', '37861', '20-Nov-2008', 'service', '2', '5-Nov-2009');

INSERT INTO PAYMENTMEDIUM VALUES ('16246', '294937.28', '12-Dec-2023', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('68811', '383197.07', '23-Jun-2018', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('52918', '306414.58', '26-Jan-2024', 'c');

INSERT INTO PAYMENTMEDIUM VALUES ('58621', '214276.77', '30-Nov-2020', 'o');

INSERT INTO PAYMENTMEDIUM VALUES ('86843', '209744.03', '3-May-2017', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('75392', '227495.97', '26-Nov-2022', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('19805', '386957.3', '3-Aug-2017', 'c');

INSERT INTO PAYMENTMEDIUM VALUES ('61611', '184303.47', '22-Dec-2016', 'o');

INSERT INTO PAYMENTMEDIUM VALUES ('17527', '84561.02', '27-Apr-2020', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('24181', '7496.89', '26-Feb-2020', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('88356', '273088.81', '27-Sep-2022', 'c');

INSERT INTO PAYMENTMEDIUM VALUES ('15684', '325590.03', '19-Feb-2022', 'o');

INSERT INTO PAYMENTMEDIUM VALUES ('72259', '189259.44', '12-Sep-2018', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('63861', '225675.07', '20-Mar-2017', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('23223', '200422.08', '19-Apr-2024', 'c');

INSERT INTO PAYMENTMEDIUM VALUES ('41618', '356833.16', '20-Jan-2023', 'o');

INSERT INTO PAYMENTMEDIUM VALUES ('8226', '268287.88', '6-May-2019', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('45890', '262971.73', '8-Nov-2024', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('91515', '332440.33', '14-Oct-2021', 'c');

INSERT INTO PAYMENTMEDIUM VALUES ('54808', '101216.81', '30-Apr-2024', 'o');

INSERT INTO PAYMENTMEDIUM VALUES ('36443', '348481.11', '28-Dec-2023', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('93196', '187017.14', '23-Feb-2021', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('92556', '204753.79', '2-Jul-2017', 'c');

INSERT INTO PAYMENTMEDIUM VALUES ('60031', '56514.29', '17-Sep-2020', 'o');

INSERT INTO PAYMENTMEDIUM VALUES ('16483', '212507.45', '1-Jun-2021', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('54364', '282827.89', '12-Nov-2020', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('82151', '182171.64', '23-Sep-2021', 'c');

INSERT INTO PAYMENTMEDIUM VALUES ('18151', '297968.95', '24-Dec-2019', 'o');

INSERT INTO PAYMENTMEDIUM VALUES ('72041', '45830.31', '17-Feb-2018', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('71982', '202756.81', '15-May-2019', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('77513', '325734.34', '18-Jan-2021', 'c');

INSERT INTO PAYMENTMEDIUM VALUES ('57504', '116207.92', '16-Jun-2021', 'o');

INSERT INTO PAYMENTMEDIUM VALUES ('43141', '342124.86', '10-Jun-2021', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('9723', '75563.06', '10-Jun-2019', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('78932', '288775.86', '1-Jan-2018', 'c');

INSERT INTO PAYMENTMEDIUM VALUES ('70121', '199704.22', '9-Sep-2019', 'o');

INSERT INTO PAYMENTMEDIUM VALUES ('3716', '305920.1', '5-Dec-2019', 'g');

INSERT INTO PAYMENTMEDIUM VALUES ('71827', '77821.12', '28-Apr-2021', 'i');

INSERT INTO PAYMENTMEDIUM VALUES ('84100', '271614.11', '10-Apr-2019', 'c');

INSERT INTO PATIENT VALUES ('105', 'Caroline', 'Windress', '7-Jan-2024', '596867456', '244');

INSERT INTO PATIENT VALUES ('106', 'Bat', 'Mason', '30-Nov-2023', '635477276', '402');

INSERT INTO PATIENT VALUES ('107', 'Lee', 'Rignall', '31-Jul-2022', '836387333', '191');

INSERT INTO PATIENT VALUES ('108', 'Parke', 'Faers', '15-Nov-2023', '124157318', '234');

INSERT INTO PATIENT VALUES ('109', 'Tyler', 'Mould', '28-Jan-2024', '20714992', '390');

INSERT INTO PATIENT VALUES ('110', 'Bekki', 'Lemary', '24-Jul-2022', '832702269', '359');

INSERT INTO PATIENT VALUES ('111', 'Geri', 'Tripcony', '11-May-2021', '12538622', '113');

INSERT INTO PATIENT VALUES ('112', 'Rikki', 'Shieldon', '26-Dec-2023', '329306265', '497');

INSERT INTO PATIENT VALUES ('113', 'Joshuah', 'Roscow', '11-Aug-2022', '459672780', '204');

INSERT INTO PATIENT VALUES ('114', 'Clement', 'Goreisr', '20-Nov-2024', '34316721', '182');

INSERT INTO PATIENT VALUES ('115', 'Ali', 'Casterton', '15-Sep-2022', '526277641', '440');

INSERT INTO PATIENT VALUES ('116', 'Aloysius', 'Mailey', '1-Dec-2021', '725579189', '170');

INSERT INTO PATIENT VALUES ('117', 'Hermann', 'Bewicke', '7-Apr-2021', '687248349', '334');

INSERT INTO PATIENT VALUES ('118', 'Benedict', 'Klimko', '3-Sep-2021', '334775897', '494');

INSERT INTO PATIENT VALUES ('119', 'Florina', 'McArt', '9-Mar-2024', '638703268', '478');

INSERT INTO PATIENT VALUES ('120', 'Devonne', 'Saggs', '21-Sep-2023', '459925055', '351');

INSERT INTO PATIENT VALUES ('121', 'Kristopher', 'Hauxley', '16-Jun-2024', '251603106', '195');

INSERT INTO PATIENT VALUES ('122', 'Morganica', 'Vedenyapin', '12-Dec-2022', '665784838', '309');

INSERT INTO PATIENT VALUES ('123', 'Currey', 'Soldan', '2-Aug-2022', '428628138', '251');

INSERT INTO PATIENT VALUES ('124', 'Quill', 'Voak', '14-Jan-2022', '753806795', '256');

INSERT INTO GUARDIAN VALUES ('41406', 'Mother', '803', '1868671', 'hadway0@privacy.gov', '12:01', '06:01', 'Hamil', 'Adaway', '244');

INSERT INTO GUARDIAN VALUES ('99316', 'Father', '669', '7011776', 'lhawod1@yolasite.com', '12:21', '06:21', 'Lonni', 'Hawkeswood', '402');

INSERT INTO GUARDIAN VALUES ('21460', 'Foster parent', '542', '9605216', 'tpacuet2@alibaba.com', '12:41', '06:41', 'Tanney', 'Pacquet', '191');

INSERT INTO GUARDIAN VALUES ('36496', 'Step-parent', '566', '9070240', 'bnials3@flickr.com', '13:01', '07:01', 'Bondon', 'Nials', '234');

INSERT INTO GUARDIAN VALUES ('22847', 'Mother', '385', '8821720', 'sgotr4@amazonaws.com', '13:21', '07:21', 'Sacha', 'Gother', '390');

INSERT INTO GUARDIAN VALUES ('46755', 'Father', '852', '1924452', 'mgbell5@newsvine.com', '13:41', '07:41', 'Martina', 'Gribbell', '359');

INSERT INTO GUARDIAN VALUES ('37244', 'Foster parent', '853', '5915279', 'bgrser6@gravatar.com', '14:01', '08:01', 'Boonie', 'Greaser', '113');

INSERT INTO GUARDIAN VALUES ('37168', 'Step-parent', '998', '4850613', 'ltimlin7@state.gov', '14:21', '08:21', 'Leanora', 'Timlin', '497');

INSERT INTO GUARDIAN VALUES ('20680', 'Mother', '232', '9462265', 'fcobson8@last.fm', '14:41', '08:41', 'Felipa', 'Cobson', '500');

INSERT INTO GUARDIAN VALUES ('93444', 'Father', '725', '5211944', 'bdehailes9@ele.com', '15:01', '09:01', 'Birgit', 'De Hailes', '182');

INSERT INTO GUARDIAN VALUES ('17195', 'Foster parent', '334', '1607101', 'lmclhana@plala.or.jp', '15:21', '09:21', 'Lezlie', 'McLenahan', '440');

INSERT INTO GUARDIAN VALUES ('84566', 'Step-parent', '451', '1433039', 'fcondb@people.com.cn', '15:41', '09:41', 'Freda', 'Cockland', '170');

INSERT INTO GUARDIAN VALUES ('53567', 'Mother', '353', '9327770', 'dbainsc@insider.com', '16:01', '10:01', 'Damita', 'Bains', '334');

INSERT INTO GUARDIAN VALUES ('62860', 'Father', '506', '1526574', 'rjolld@over-blog.com', '16:21', '10:21', 'Robb', 'Jolly', '494');

INSERT INTO GUARDIAN VALUES ('53155', 'Foster parent', '901', '7351093', 'ftraute@nbcnews.com', '16:41', '10:41', 'Fredek', 'Traut', '478');

INSERT INTO GUARDIAN VALUES ('93985', 'Step-parent', '664', '9823711', 'mebbersf@ebay.co.uk', '17:01', '11:01', 'Mile', 'Ebbers', '351');

INSERT INTO GUARDIAN VALUES ('60749', 'Mother', '111', '6960014', 'rraveng@sphinn.com', '17:21', '11:21', 'Randolph', 'Raven', '195');

INSERT INTO GUARDIAN VALUES ('41218', 'Father', '117', '9123816', 'clivockh@wsj.com', '17:41', '11:41', 'Conrad', 'Livock', '501');

INSERT INTO GUARDIAN VALUES ('91424', 'Foster parent', '418', '7853837', 'dfei@advertising.org', '18:01', '12:01', 'Dalenna', 'Tordiffe', '251');

INSERT INTO GUARDIAN VALUES ('30547', 'Step-parent', '405', '2060167', 'reliotj@ow.ly', '18:21', '12:21', 'Robin', 'Eliot', '256');

INSERT INTO GUARDIAN VALUES ('48053', 'Mother', '985', '1753907', 'dalldek@usatoday.com', '18:41', '12:41', 'Danette', 'Alldridge', '432');

INSERT INTO GUARDIAN VALUES ('58332', 'Father', '302', '5476114', 'zboijl@answers.com', '19:01', '13:01', 'Zonda', 'Boij', '502');

INSERT INTO GUARDIAN VALUES ('26125', 'Foster parent', '341', '6488117', 'csahnowm@sina.com.cn', '19:21', '13:21', 'Cacilie', 'Sahnow', '419');

INSERT INTO GUARDIAN VALUES ('41309', 'Step-parent', '741', '9922545', 'lmoliann@google.nl', '19:41', '13:41', 'Lenard', 'Molian', '339');

INSERT INTO GUARDIAN VALUES ('85315', 'Mother', '360', '5460519', 'hpryoro@ask.com', '20:01', '14:01', 'Hettie', 'Pryor', '443');

INSERT INTO GUARDIAN VALUES ('56292', 'Mother', '785', '3364907', 'kmelssp@so-net.ne.jp', '20:21', '14:21', 'Kelbee', 'Melpuss', '503');

INSERT INTO GUARDIAN VALUES ('66220', 'Mother', '412', '9646952', 'cbyq@theguardian.com', '20:41', '14:41', 'Cindee', 'Eshelby', '127');

INSERT INTO GUARDIAN VALUES ('24878', 'Mother', '914', '7994521', 'ahardlr@amazon.co.uk', '21:01', '15:01', 'Annora', 'Hardwell', '480');

INSERT INTO GUARDIAN VALUES ('24698', 'Mother', '766', '3464274', 'gmaoughens@house.gov', '21:21', '15:21', 'Georgi', 'MacCoughen', '377');

INSERT INTO GUARDIAN VALUES ('77509', 'Mother', '940', '9186721', 'eharmart@loc.gov', '21:41', '15:41', 'Engracia', 'Harmar', '201');

INSERT INTO GUARDIAN VALUES ('20670', 'Mother', '966', '1516220', 'zrollou@icq.com', '22:01', '16:01', 'Zane', 'Rollo', '108');

INSERT INTO GUARDIAN VALUES ('88340', 'Mother', '425', '9570553', 'gbusfieldv@cc.com', '22:21', '16:21', 'Gerty', 'Busfield', '183');

INSERT INTO GUARDIAN VALUES ('66128', 'Mother', '261', '2495738', 'handhw@xinhuanet.com', '22:41', '16:41', 'Hortense', 'Andersch', '474');

INSERT INTO GUARDIAN VALUES ('40757', 'Mother', '861', '3493323', 'aegarrx@google.nl', '23:01', '17:01', 'Anita', 'Egarr', '482');

INSERT INTO GUARDIAN VALUES ('64941', 'Mother', '649', '7659733', 'niredelly@apple.com', '23:21', '17:21', 'Norah', 'Iredell', '504');

INSERT INTO GUARDIAN VALUES ('50125', 'Mother', '961', '8538458', 'vtuddenhamz@digg.com', '23:41', '17:41', 'Violette', 'Tuddenham', '206');

INSERT INTO GUARDIAN VALUES ('22661', 'Mother', '274', '4060415', 'arosita10@is.gd', '00:01', '18:01', 'Augustine', 'Rosita', '187');

INSERT INTO GUARDIAN VALUES ('12284', 'Mother', '745', '3521805', 'hstein11@dev.com', '00:21', '18:21', 'Herculie', 'Schleswig-Holstein', '204');

INSERT INTO GUARDIAN VALUES ('67758', 'Father', '760', '3474003', 'ifattorini12@bbb.org', '00:41', '18:41', 'Isador', 'Fattorini', '271');

INSERT INTO GUARDIAN VALUES ('49253', 'Father', '712', '5507631', 'ogoulborne13@npr.org', '01:01', '19:01', 'Oneida', 'Goulborne', '188');

INSERT INTO GUARDIAN VALUES ('71308', 'Father', '443', '8656129', 'bdixson14@apache.org', '01:21', '19:21', 'Basil', 'Dixson', '166');

INSERT INTO GUARDIAN VALUES ('89048', 'Father', '190', '7602190', 'fabn15@biglobe.ne.jp', '01:41', '19:41', 'Felicdad', 'Abotson', '133');

INSERT INTO GUARDIAN VALUES ('87568', 'Father', '788', '7322559', 'flestrge16@prlog.org', '02:01', '20:01', 'Fabiano', 'Estrange', '120');

INSERT INTO GUARDIAN VALUES ('27365', 'Father', '818', '1394941', 'nclwe17@linkedin.com', '02:21', '20:21', 'Nadya', 'Clewlowe', '205');

INSERT INTO GUARDIAN VALUES ('73681', 'Father', '229', '5654722', 'hhaides18@dyndns.org', '02:41', '20:41', 'Helen-elizabeth', 'Havesides', '386');

INSERT INTO GUARDIAN VALUES ('93373', 'Father', '692', '4081292', 'bbi9@stumbleupon.com', '03:01', '21:01', 'Ben', 'Bizley', '267');

INSERT INTO GUARDIAN VALUES ('97078', 'Father', '799', '9736617', 'rlarchea@comsenz.com', '03:21', '21:21', 'Rowen', 'Larcher', '309');

INSERT INTO GUARDIAN VALUES ('78381', 'Father', '509', '4068318', 'cpilkion1b@naver.com', '03:41', '21:41', 'Conrad', 'Pilkington', '258');

INSERT INTO GUARDIAN VALUES ('20135', 'Father', '730', '8957194', 'wlomc@wikispaces.com', '04:01', '22:01', 'Wilfrid', 'Lomas', '353');

INSERT INTO GUARDIAN VALUES ('17204', 'Father', '713', '6082062', 'sr1d@studiopress.com', '04:21', '22:21', 'Sallie', 'Redier', '233');

INSERT INTO GUARDIAN VALUES ('66800', 'Father', '990', '8110643', 'bfreeburn1e@bbb.org', '04:41', '22:41', 'Betti', 'Freeburn', '200');

INSERT INTO GUARDIAN VALUES ('13401', 'Father', '653', '6890902', 'cattryde1f@xing.com', '05:01', '23:01', 'Cynde', 'Attryde', '407');

INSERT INTO GUARDIAN VALUES ('38265', 'Father', '629', '7055318', 'glune1g@phpbb.com', '05:21', '23:21', 'Grenville', 'Lune', '350');

INSERT INTO GUARDIAN VALUES ('79094', 'Father', '255', '6759773', 'ehah@nydailynews.com', '05:41', '23:41', 'Edee', 'Hayen', '288');

INSERT INTO GUARDIAN VALUES ('81566', 'Father', '775', '1071822', 'akeysel1i@apache.org', '06:01', '00:01', 'Alaric', 'Keysel', '438');

INSERT INTO GUARDIAN VALUES ('67118', 'Father', '179', '1917651', 'abewsey1j@umich.edu', '06:21', '00:21', 'Antonetta', 'Bewsey', '442');

INSERT INTO GUARDIAN VALUES ('54916', 'Father', '136', '8550422', 'bgare1k@columbia.edu', '06:41', '00:41', 'Beulah', 'Garrique', '383');

INSERT INTO GUARDIAN VALUES ('51097', 'Father', '189', '7809461', 'cdyba1l@amazon.co.jp', '07:01', '01:01', 'Christine', 'Dybald', '104');

INSERT INTO GUARDIAN VALUES ('48625', 'Father', '784', '2784622', 'ojacomb1m@rambler.ru', '07:21', '01:21', 'Orson', 'Jacomb', '388');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('8226', '6767984612', '504837611', 'HMO', '5-Nov-2030', '581');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('45890', '3540420584', '504837299', 'PPO', '5-Oct-2027', '14');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('91515', '5427165210', '510875882', 'EPO', '19-Sep-2030', '93');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('54808', '5602254225', '510875188', 'POS', '27-Aug-2029', '319');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('36443', '6331108146', '510875238', 'HDHP', '31-Oct-2030', '170');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('93196', '0604378158', '510875998', 'HAS', '9-Aug-2030', '552');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('92556', '3565234749', '504837316', 'HMO', '6-Jul-2026', '258');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('60031', '5100134262', '504837506', 'PPO', '14-Nov-2025', '241');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('16483', '5587475266', '510875203', 'EPO', '22-Feb-2030', '21');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('54364', '5108758694', '504837465', 'POS', '25-Aug-2026', '504');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('82151', '5587383508', '510875635', 'HDHP', '12-Apr-2028', '581');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('18151', '3540286069', '504837205', 'HAS', '28-Aug-2026', '14');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('72041', '3543479881', '510875262', 'HMO', '30-Aug-2028', '93');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('71982', '5320255829', '510875117', 'PPO', '1-Mar-2029', '319');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('77513', '5602214219', '510875716', 'EPO', '24-Apr-2025', '170');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('57504', '3560331976', '510875288', 'POS', '27-Jan-2029', '552');

INSERT INTO HEALTHINSURANCEPOLICY VALUES ('43141', '3579640952', '504837660', 'HDHP', '23-Jan-2025', '258');

INSERT INTO CHARITABLEORGANIZATION VALUES ('16246', 'St. Jude', '4043762454', 'cst@businesswire.com', '3 Arapahoe Pass', 'Atlanta', 'GA', '31547');

INSERT INTO CHARITABLEORGANIZATION VALUES ('68811', 'Koch-Gleason', '8019118752', 'tgre1@parallels.com', '33 Fair Oaks Terrace', 'Salt Lake City', 'UT', '65345');

INSERT INTO CHARITABLEORGANIZATION VALUES ('52918', 'Bernhard-Hoppe', '5206077469', 'rfattorini2@sky.com', '443 Bunting Way', 'Tucson', 'AZ', '35544');

INSERT INTO CHARITABLEORGANIZATION VALUES ('58621', 'Wolf and Hayes', '9138452836', 'sdurdle3@drupal.org', '8 Dorton Hill', 'Kansas City', 'KS', '58676');

INSERT INTO CHARITABLEORGANIZATION VALUES ('86843', 'Hudson and Johns', '5156244300', 'abl@aboutads.info', '2484 Sachtjen Crossing', 'Des Moines', 'IA', '10796');

INSERT INTO CHARITABLEORGANIZATION VALUES ('75392', 'Collins and Homenick', '2063349258', 'sackland5@com.com', '797 Gina Junction', 'Seattle', 'WA', '40270');

INSERT INTO CHARITABLEORGANIZATION VALUES ('19805', 'Moore Group', '5401212128', 'echolton6@zdnet.com', '17065 Golf Avenue', 'Charlottesville', 'VA', '82470');

INSERT INTO CHARITABLEORGANIZATION VALUES ('61611', 'Windler Group', '3153472596', 'adutnall7@the.com', '3 Waywood Avenue', 'Rochester', 'NY', '89291');

INSERT INTO CHARITABLEORGANIZATION VALUES ('17527', 'Monahan Inc', '9155704648', 'cweeks8@addthis.com', '053 Arapahoe Trail', 'El Paso', 'TX', '65202');

INSERT INTO CHARITABLEORGANIZATION VALUES ('24181', 'Lowe, Conn and Dare', '3098171730', 'rroa@discovery.com', '763 Northport Court', 'Peoria', 'IL', '34542');

INSERT INTO CHARITABLEORGANIZATION VALUES ('88356', 'Bayer LLC', '5133472878', 'arussia@jigsy.com', '680 Kenwood Road', 'Cincinnati', 'OH', '99873');

INSERT INTO CHARITABLEORGANIZATION VALUES ('15684', 'Crona-Friesen', '4841663223', 'cbroz@redcross.org', '9 Meadow Vale Parkway', 'Reading', 'PA', '33866');

INSERT INTO CHARITABLEORGANIZATION VALUES ('72259', 'Gulgowski and Orn', '4159844832', 'ebrun@reuters.com', '4227 Mallard Crossing', 'San Francisco', 'CA', '96142');

INSERT INTO CHARITABLEORGANIZATION VALUES ('63861', 'Lemke and Klein', '2068357052', 'htoo@dyndns.org', '9 Westend Trail', 'Seattle', 'WA', '80170');

INSERT INTO CHARITABLEORGANIZATION VALUES ('23223', 'Weimann and Spencer', '6782824249', 'nrawlee@ft.com', '9 Oak Drive', 'Duluth', 'GA', '19773');

INSERT INTO CHARITABLEORGANIZATION VALUES ('41618', 'Pouros-Wisoky', '2562838908', 'dlicciardiellof@ed', '24217 Dawn Circle', 'Huntsville', 'AL', '18032');

INSERT INTO GUARDIANPAYMENT VALUES ('9723', '5100140846517573', '3567', '41406');

INSERT INTO GUARDIANPAYMENT VALUES ('78932', '3531691762872636', '5436', '99316');

INSERT INTO GUARDIANPAYMENT VALUES ('70121', '4936568150600184', '78907', '21460');

INSERT INTO GUARDIANPAYMENT VALUES ('3716', '6763631348822475', '34456', '36496');

INSERT INTO GUARDIANPAYMENT VALUES ('71827', '5551260009395114', '2768', '22847');

INSERT INTO GUARDIANPAYMENT VALUES ('84100', '3559712533869474', '6783', '46755');

INSERT INTO PAYMENT VALUES ('1290', '294937.28', 'check', 'Check number 257', '16246', '105');

INSERT INTO PAYMENT VALUES ('25764', '383197.07', 'cash', 'Reciept 811', '68811', '106');

INSERT INTO PAYMENT VALUES ('35415', '306414.58', 'credit', 'Bank confirmed', '52918', '107');

INSERT INTO PAYMENT VALUES ('57760', '214276.77', 'transfer', 'Confirmed', '58621', '108');

INSERT INTO PAYMENT VALUES ('67957', '209744.03', 'debit', 'Credit checked', '86843', '109');

INSERT INTO PAYMENT VALUES ('4741', '227495.97', 'check', 'Check number 234', '75392', '110');

INSERT INTO PAYMENT VALUES ('23474', '386957.3', 'cash', 'Reciept 805', '19805', '111');

INSERT INTO PAYMENT VALUES ('49470', '184303.47', 'credit', 'Bank confirmed', '61611', '112');

INSERT INTO PAYMENT VALUES ('80190', '84561.02', 'transfer', 'Confirmed', '17527', '113');

INSERT INTO PAYMENT VALUES ('89058', '7496.89', 'debit', 'Credit checked', '24181', '114');

INSERT INTO PAYMENT VALUES ('59616', '273088.81', 'check', 'Check number 187', '88356', '115');

INSERT INTO PAYMENT VALUES ('18781', '325590.03', 'cash', 'Reciept 684', '15684', '116');

INSERT INTO PAYMENT VALUES ('98042', '189259.44', 'credit', 'Bank confirmed', '72259', '117');

INSERT INTO PAYMENT VALUES ('92129', '225675.07', 'transfer', 'Confirmed', '63861', '118');

INSERT INTO PAYMENT VALUES ('45218', '200422.08', 'debit', 'Credit checked', '23223', '119');

INSERT INTO PAYMENT VALUES ('54112', '356833.16', 'check', 'Check number 988', '41618', '120');

INSERT INTO PAYMENT VALUES ('98895', '268287.88', 'cash', 'Reciept 226', '8226', '121');

INSERT INTO PAYMENT VALUES ('20491', '262971.73', 'credit', 'Bank confirmed', '45890', '122');

INSERT INTO PAYMENT VALUES ('5687', '332440.33', 'transfer', 'Confirmed', '91515', '123');

INSERT INTO PAYMENT VALUES ('1000', '101216.81', 'debit', 'Credit checked', '54808', '124');

INSERT INTO PAYMENT VALUES ('86081', '348481.11', 'check', 'Check number 224', '36443', '105');

INSERT INTO PAYMENT VALUES ('22424', '187017.14', 'cash', 'Reciept 196', '93196', '106');

INSERT INTO PAYMENT VALUES ('16830', '204753.79', 'credit', 'Bank confirmed', '92556', '107');

INSERT INTO PAYMENT VALUES ('5705', '56514.29', 'transfer', 'Confirmed', '60031', '108');

INSERT INTO PAYMENT VALUES ('18904', '212507.45', 'debit', 'Credit checked', '16483', '109');

INSERT INTO PAYMENT VALUES ('94455', '282827.89', 'check', 'Check number 6926', '54364', '110');

INSERT INTO PAYMENT VALUES ('69261', '182171.64', 'cash', 'Reciept 151', '82151', '111');

INSERT INTO PAYMENT VALUES ('87714', '297968.95', 'credit', 'Bank confirmed', '18151', '112');

INSERT INTO PAYMENT VALUES ('97348', '45830.31', 'transfer', 'Confirmed', '72041', '113');

INSERT INTO PAYMENT VALUES ('62453', '202756.81', 'debit', 'Credit checked', '71982', '114');

INSERT INTO PAYMENT VALUES ('39167', '325734.34', 'check', 'Check number 155', '77513', '115');

INSERT INTO PAYMENT VALUES ('15561', '116207.92', 'cash', 'Reciept 504', '57504', '116');

INSERT INTO PAYMENT VALUES ('1375', '342124.86', 'credit', 'Bank confirmed', '43141', '117');

INSERT INTO PAYMENT VALUES ('36554', '75563.06', 'transfer', 'Confirmed', '9723', '118');

INSERT INTO PAYMENT VALUES ('64409', '288775.86', 'debit', 'Credit checked', '78932', '119');

INSERT INTO PAYMENT VALUES ('6021', '199704.22', 'check', 'Check number 7956', '70121', '120');

INSERT INTO PAYMENT VALUES ('7956', '305920.1', 'cash', 'Reciept 716', '3716', '121');

INSERT INTO PAYMENT VALUES ('41618', '77821.12', 'credit', 'Bank confirmed', '71827', '122');

INSERT INTO PAYMENT VALUES ('60517', '271614.11', 'transfer', 'Confirmed', '84100', '123');

INSERT INTO GUARDIANSHIP VALUES ('105', '41406');

INSERT INTO GUARDIANSHIP VALUES ('106', '99316');

INSERT INTO GUARDIANSHIP VALUES ('107', '21460');

INSERT INTO GUARDIANSHIP VALUES ('108', '36496');

INSERT INTO GUARDIANSHIP VALUES ('109', '22847');

INSERT INTO GUARDIANSHIP VALUES ('110', '46755');

INSERT INTO GUARDIANSHIP VALUES ('111', '37244');

INSERT INTO GUARDIANSHIP VALUES ('112', '37168');

INSERT INTO GUARDIANSHIP VALUES ('113', '20680');

INSERT INTO GUARDIANSHIP VALUES ('114', '93444');

INSERT INTO GUARDIANSHIP VALUES ('115', '17195');

INSERT INTO GUARDIANSHIP VALUES ('116', '84566');

INSERT INTO GUARDIANSHIP VALUES ('117', '53567');

INSERT INTO GUARDIANSHIP VALUES ('118', '62860');

INSERT INTO GUARDIANSHIP VALUES ('119', '53155');

INSERT INTO GUARDIANSHIP VALUES ('120', '93985');

INSERT INTO GUARDIANSHIP VALUES ('121', '60749');

INSERT INTO GUARDIANSHIP VALUES ('122', '41218');

INSERT INTO GUARDIANSHIP VALUES ('123', '91424');

INSERT INTO GUARDIANSHIP VALUES ('124', '30547');

INSERT INTO PATIENTALLERGY VALUES ('113', 'Food', 'undetectable', 'hives');

INSERT INTO PATIENTALLERGY VALUES ('114', 'Drug', 'mild', 'hives');

INSERT INTO PATIENTALLERGY VALUES ('115', 'Insect', 'moderate', 'hives');

INSERT INTO PATIENTALLERGY VALUES ('116', 'Pet', 'severe', 'hives');

INSERT INTO PATIENTALLERGY VALUES ('117', 'Mold', 'life-threatening', 'hives');

INSERT INTO PATIENTALLERGY VALUES ('118', 'Pollen', 'undetectable', 'hives');

INSERT INTO PATIENTALLERGY VALUES ('119', 'Latex', 'mild', 'hives');

INSERT INTO PATIENTALLERGY VALUES ('120', 'Food', 'moderate', 'anaphylaxis');

INSERT INTO PATIENTALLERGY VALUES ('121', 'Drug', 'severe', 'anaphylaxis');

INSERT INTO PATIENTALLERGY VALUES ('122', 'Insect', 'life-threatening', 'anaphylaxis');

INSERT INTO PATIENTALLERGY VALUES ('123', 'Pet', 'undetectable', 'anaphylaxis');

INSERT INTO PATIENTALLERGY VALUES ('124', 'Pollen', 'undetectable', 'anaphylaxis');

INSERT INTO PATIENTCONDITION VALUES ('113', 'Respiratory Infec', 'undetectable', '10-Jul-2005', 'Monitor');

INSERT INTO PATIENTCONDITION VALUES ('114', 'High Cholesterol', 'mild', '8-Dec-2021', 'Medical care');

INSERT INTO PATIENTCONDITION VALUES ('115', 'Hypertension', 'moderate', '19-Jul-2008', 'Active treatment');

INSERT INTO PATIENTCONDITION VALUES ('116', 'Type 2 Diabetes', 'severe', '23-Apr-2020', 'Page Doctor');

INSERT INTO PATIENTCONDITION VALUES ('117', 'COPD', 'life-threatening', '7-Oct-2010', 'High alert');

INSERT INTO PATIENTCONDITION VALUES ('118', 'Acid reflux', 'undetectable', '9-Sep-2003', 'Monitor');

INSERT INTO PATIENTCONDITION VALUES ('119', 'Cancer', 'mild', '3-Jun-2021', 'Medical care');

INSERT INTO PATIENTCONDITION VALUES ('120', 'Cancer', 'moderate', '25-Feb-2010', 'Active treatment');

INSERT INTO PATIENTCONDITION VALUES ('121', 'Cancer', 'severe', '16-Apr-2001', 'Page Doctor');

INSERT INTO PATIENTCONDITION VALUES ('122', 'Cancer', 'life-threatening', '16-Feb-2018', 'High alert');

INSERT INTO PATIENTCONDITION VALUES ('123', 'Cancer', 'mild', '26-Oct-2009', 'Monitor');

INSERT INTO PATIENTCONDITION VALUES ('124', 'Cancer', 'mild', '22-Feb-2020', 'Medical care');

INSERT INTO PATIENTVISIT VALUES ('537', '14-Oct-2012', 'Cough', 'Starts intake process', '105');

INSERT INTO PATIENTVISIT VALUES ('809', '19-May-2001', 'Unable to sleep', 'Starts intake process', '106');

INSERT INTO PATIENTVISIT VALUES ('627', '14-May-2016', 'Tired', 'Starts intake process', '107');

INSERT INTO PATIENTVISIT VALUES ('507', '28-Dec-2017', 'leg pain', 'Moved beds first night', '108');

INSERT INTO PATIENTVISIT VALUES ('690', '7-Jul-2008', 'Fever', 'Moved beds first night', '109');

INSERT INTO PATIENTVISIT VALUES ('749', '27-Jul-2022', 'chills', 'Moved beds first night', '110');

INSERT INTO PATIENTVISIT VALUES ('465', '18-Mar-2006', 'short of breath', 'Ready for discharge', '111');

INSERT INTO PATIENTVISIT VALUES ('520', '27-Oct-2017', 'Unable to move arm', 'Ready for discharge', '112');

INSERT INTO PATIENTVISIT VALUES ('883', '20-Jan-2020', 'Losing hearing', 'Ready for discharge', '113');

INSERT INTO PATIENTVISIT VALUES ('547', '8-Dec-2010', 'Sounds too loud', 'Ready for discharge', '114');

INSERT INTO PATIENTVISIT VALUES ('812', '9-Nov-2009', 'Unable to speak normally', 'Ready for discharge', '115');

INSERT INTO PATIENTVISIT VALUES ('491', '28-Mar-2006', 'Lack of taste', 'Need to confirm medical information', '116');

INSERT INTO PATIENTVISIT VALUES ('833', '10-Feb-2020', 'Always thirsty', 'Need to confirm medical information', '117');

INSERT INTO PATIENTVISIT VALUES ('891', '27-Nov-2001', 'Nauseated', 'Need to confirm medical information', '118');

INSERT INTO PATIENTVISIT VALUES ('433', '7-Jun-2023', 'Dizzy', 'Need to confirm medical information', '119');

INSERT INTO PATIENTVISIT VALUES ('813', '25-Apr-2020', 'Light-headed', 'Need to confirm medical information', '120');

INSERT INTO PATIENTVISIT VALUES ('546', '11-Jan-2006', 'blurred vision', 'Need to confirm medical information', '121');

INSERT INTO PATIENTVISIT VALUES ('484', '31-Mar-2018', 'Unable to swallow', 'Need to confirm medical information', '122');

INSERT INTO PATIENTVISIT VALUES ('590', '15-Feb-2008', 'Back pain', 'Need to confirm medical information', '123');

INSERT INTO PATIENTVISIT VALUES ('435', '30-Jul-2002', 'Skin itches', 'Need to confirm medical information', '124');

INSERT INTO PASTSURGERY VALUES ('402', 'Dacryocystorhinostomy', '14-Apr-2014', 'No follow up needed.', 'Eli Compton', '7054993706', '105');

INSERT INTO PASTSURGERY VALUES ('837', 'Iridectomy ', '30-Dec-2017', 'No follow up needed.', 'Carleen Boobier', '4574762940', '106');

INSERT INTO PASTSURGERY VALUES ('678', 'Ganglionectomy', '15-Oct-2019', 'No follow up needed.', 'Saunders Bartels', '2214008939', '107');

INSERT INTO PASTSURGERY VALUES ('566', 'Ventriculostomy', '25-Sep-2021', 'Needs urgrent attention.', 'Linette Bernaldez', '7841807145', '108');

INSERT INTO PASTSURGERY VALUES ('871', 'Cordotomy', '8-Oct-2023', 'Needs urgrent attention.', 'Kellsie Cholton', '7433808214', '109');

INSERT INTO PASTSURGERY VALUES ('420', 'Septoplasty', '6-Dec-2012', 'Needs urgrent attention.', 'Bree Fussell', '1395649201', '110');

INSERT INTO PASTSURGERY VALUES ('524', 'Otoplasty', '6-Dec-2022', 'Check up in 40 days.', 'Sherilyn Yakobowitz', '5279973370', '111');

INSERT INTO PASTSURGERY VALUES ('723', 'Myringotomy', '4-May-2012', 'Check up in 40 days.', 'Nicolis Liddicoat', '7407649839', '112');

INSERT INTO PASTSURGERY VALUES ('589', 'Ganglionectomy', '11-Apr-2017', 'Check up in 40 days.', 'Janis Brickham', '9815741035', '113');

INSERT INTO PASTSURGERY VALUES ('820', 'Cardiotomy', '30-Jan-2023', 'Check up in 40 days.', 'Lonnie Clutton', '8071828008', '114');

INSERT INTO PASTSURGERY VALUES ('615', 'Angioplasty', '19-Jul-2012', 'Check up in 40 days.', 'Lauren Simonou', '5354187268', '115');

INSERT INTO PASTSURGERY VALUES ('812', 'Pneumonectomy', '6-Feb-2014', 'All went well.', 'Shelley Kid', '5749260055', '116');

INSERT INTO PASTSURGERY VALUES ('768', 'Bronchotomy', '8-Sep-2013', 'All went well.', 'Lark Jacmard', '2865479880', '117');

INSERT INTO PASTSURGERY VALUES ('618', 'Mentoplasty ', '17-Jan-2022', 'All went well.', 'Becca Melbert', '1545998089', '118');

INSERT INTO PASTSURGERY VALUES ('898', 'Laminotomy ', '28-Jan-2024', 'All went well.', 'Vidovic Hazelgreave', '5626236555', '119');

INSERT INTO EQUIPMENTUSED VALUES ('1', '537');

INSERT INTO EQUIPMENTUSED VALUES ('2', '809');

INSERT INTO EQUIPMENTUSED VALUES ('3', '627');

INSERT INTO EQUIPMENTUSED VALUES ('4', '507');

INSERT INTO EQUIPMENTUSED VALUES ('5', '690');

INSERT INTO EQUIPMENTUSED VALUES ('6', '749');

INSERT INTO EQUIPMENTUSED VALUES ('7', '465');

INSERT INTO EQUIPMENTUSED VALUES ('8', '520');

INSERT INTO EQUIPMENTUSED VALUES ('9', '883');

INSERT INTO EQUIPMENTUSED VALUES ('10', '547');

INSERT INTO EQUIPMENTUSED VALUES ('11', '812');

INSERT INTO EQUIPMENTUSED VALUES ('12', '491');

INSERT INTO EQUIPMENTUSED VALUES ('13', '833');

INSERT INTO EQUIPMENTUSED VALUES ('14', '891');

INSERT INTO EQUIPMENTUSED VALUES ('15', '433');

INSERT INTO EQUIPMENTUSED VALUES ('16', '813');

INSERT INTO EQUIPMENTUSED VALUES ('17', '546');

INSERT INTO EQUIPMENTUSED VALUES ('18', '484');

INSERT INTO EQUIPMENTUSED VALUES ('19', '590');

INSERT INTO EQUIPMENTUSED VALUES ('20', '435');

INSERT INTO FUTUREAPPOINTMENT VALUES ('664', '12-Jun-2029', 'Check-in', '537');

INSERT INTO FUTUREAPPOINTMENT VALUES ('405', '26-Jun-2029', 'Check-in', '809');

INSERT INTO FUTUREAPPOINTMENT VALUES ('892', '15-Nov-2028', 'Surgery', '627');

INSERT INTO FUTUREAPPOINTMENT VALUES ('499', '26-Apr-2029', 'Post-op', '507');

INSERT INTO FUTUREAPPOINTMENT VALUES ('414', '12-Jul-2030', 'Treatment', '690');

INSERT INTO FUTUREAPPOINTMENT VALUES ('517', '17-Nov-2030', 'Pre-op', '749');

INSERT INTO FUTUREAPPOINTMENT VALUES ('401', '16-Aug-2028', 'Check-in', '465');

INSERT INTO FUTUREAPPOINTMENT VALUES ('836', '23-Sep-2029', 'Check-in', '520');

INSERT INTO FUTUREAPPOINTMENT VALUES ('766', '17-Mar-2027', 'Surgery', '883');

INSERT INTO FUTUREAPPOINTMENT VALUES ('689', '31-Jan-2030', 'Post-op', '547');

INSERT INTO FUTUREAPPOINTMENT VALUES ('709', '13-Apr-2030', 'Treatment', '812');

INSERT INTO FUTUREAPPOINTMENT VALUES ('865', '2-Dec-2027', 'Pre-op', '491');

INSERT INTO FUTUREAPPOINTMENT VALUES ('821', '9-Jun-2028', 'Treatment', '833');

INSERT INTO SERVICEATVISIT VALUES ('537', '756', '2', '70403.54');

INSERT INTO SERVICEATVISIT VALUES ('809', '648', '3', '13879.23');

INSERT INTO SERVICEATVISIT VALUES ('627', '684', '4', '103791.64');

INSERT INTO SERVICEATVISIT VALUES ('507', '546', '1', '46489.19');

INSERT INTO SERVICEATVISIT VALUES ('690', '442', '2', '80173.96');

INSERT INTO SERVICEATVISIT VALUES ('749', '778', '3', '94826.49');

INSERT INTO SERVICEATVISIT VALUES ('465', '664', '2', '8539.5');

INSERT INTO SERVICEATVISIT VALUES ('520', '878', '4', '43513.84');

INSERT INTO SERVICEATVISIT VALUES ('883', '860', '3', '22420.95');

INSERT INTO SERVICEATVISIT VALUES ('547', '819', '4', '45241.52');

INSERT INTO SERVICEATVISIT VALUES ('812', '508', '3', '11559.81');

INSERT INTO SERVICEATVISIT VALUES ('491', '490', '2', '73380.24');

INSERT INTO SERVICEATVISIT VALUES ('833', '463', '3', '138406.77');

INSERT INTO SERVICEATVISIT VALUES ('891', '680', '3', '18561.69');

INSERT INTO SERVICEATVISIT VALUES ('433', '548', '1', '28850.49');

INSERT INTO SERVICEATVISIT VALUES ('813', '503', '2', '7447.06');

INSERT INTO SERVICEATVISIT VALUES ('546', '462', '4', '188591.24');

INSERT INTO SERVICEATVISIT VALUES ('484', '488', '3', '134063.04');

INSERT INTO SERVICEATVISIT VALUES ('590', '886', '2', '26032.56');

INSERT INTO SERVICEATVISIT VALUES ('435', '853', '4', '158956.92');

