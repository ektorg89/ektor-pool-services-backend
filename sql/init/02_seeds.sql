INSERT INTO users (username, email, hashed_password, role, is_active)
VALUES (
  'ektor',
  'ektor@eps.com',
  '$2b$12$qsgcJPdmbhAUg2MtKEWff.COyRTBk6kjCYD3/YCJ6Cf.Hf2gU2ZuG',
  'admin',
  1
)
ON DUPLICATE KEY UPDATE
  role = VALUES(role),
  is_active = VALUES(is_active);
  
INSERT INTO technicians (name, phone, email)
VALUES ('Ektor Gonzalez', '787-555-0001', 'ektor.gonzalez@eps.com');

SET @tech_ektor := (SELECT technician_id FROM technicians WHERE email='ektor.gonzalez@eps.com');

INSERT INTO customers (first_name, last_name, phone, email) VALUES
('Martha',   'Perez',       '787-555-0101', 'martha.perez@eps.com'),
('Pete',     'Stockton',    '787-555-0102', 'pete.stockton@eps.com'),
('Michael',  'Perry',       '787-555-0103', 'michael.perry@eps.com'),
('Dwayne',   'Johnson',     '787-555-0104', 'dwayne.johnson@eps.com'),
('Sabrina',  'Danielson',   '787-555-0105', 'sabrina.danielson@eps.com'),
('Jean',     'Paul',        '787-555-0106', 'jean.paul@eps.com'),
('Christian','Clive',       '787-555-0107', 'christian.clive@eps.com');

SET @cust_martha   := (SELECT customer_id FROM customers WHERE email='martha.perez@eps.com');
SET @cust_pete     := (SELECT customer_id FROM customers WHERE email='pete.stockton@eps.com');
SET @cust_michael  := (SELECT customer_id FROM customers WHERE email='michael.perry@eps.com');
SET @cust_dwayne   := (SELECT customer_id FROM customers WHERE email='dwayne.johnson@eps.com');
SET @cust_sabrina  := (SELECT customer_id FROM customers WHERE email='sabrina.danielson@eps.com');
SET @cust_jean     := (SELECT customer_id FROM customers WHERE email='jean.paul@eps.com');
SET @cust_christian:= (SELECT customer_id FROM customers WHERE email='christian.clive@eps.com');

INSERT INTO properties (customer_id, label, address1, city, state, postal_code) VALUES
(@cust_martha,    'Martha Residence',          '100 Ocean View St', 'Rincon', 'PR', '00677'),
(@cust_pete,      'Stockton Family Estate',    '200 Palm Dr',       'Aguadilla', 'PR', '00603'),
(@cust_michael,   'Perry Residence',           '300 Sunset Ave',    'Isabela', 'PR', '00662'),
(@cust_dwayne,    'Johnson Home',              '400 Hilltop Rd',    'Mayaguez', 'PR', '00680'),
(@cust_sabrina,   'Danielson Villa',           '500 Coastline Blvd','Cabo Rojo','PR','00623'),
(@cust_jean,      'Jean Paul Residence',       '600 Coral Ln',      'Moca', 'PR', '00676'),
(@cust_jean,      'Jean Paul Beach House',     '700 Beachfront Way','Rincon', 'PR', '00677'),
(@cust_christian, 'Clive Residence',           '800 Garden St',     'Aguada', 'PR', '00602');

SET @prop_martha     := (SELECT property_id FROM properties WHERE customer_id=@cust_martha AND label='Martha Residence');
SET @prop_pete       := (SELECT property_id FROM properties WHERE customer_id=@cust_pete AND label='Stockton Family Estate');
SET @prop_michael    := (SELECT property_id FROM properties WHERE customer_id=@cust_michael AND label='Perry Residence');
SET @prop_dwayne     := (SELECT property_id FROM properties WHERE customer_id=@cust_dwayne AND label='Johnson Home');
SET @prop_sabrina    := (SELECT property_id FROM properties WHERE customer_id=@cust_sabrina AND label='Danielson Villa');
SET @prop_jean_home  := (SELECT property_id FROM properties WHERE customer_id=@cust_jean AND label='Jean Paul Residence');
SET @prop_jean_beach := (SELECT property_id FROM properties WHERE customer_id=@cust_jean AND label='Jean Paul Beach House');
SET @prop_christian  := (SELECT property_id FROM properties WHERE customer_id=@cust_christian AND label='Clive Residence');

INSERT INTO pools (property_id, label, pool_type, surface) VALUES
(@prop_martha, 'Main Pool', 'pool', 'plaster');

INSERT INTO pools (property_id, label, pool_type, surface) VALUES
(@prop_pete, 'Pool 1', 'pool', 'plaster'),
(@prop_pete, 'Pool 2', 'pool', 'plaster'),
(@prop_pete, 'Pool 3', 'pool', 'plaster'),
(@prop_pete, 'Pool 4', 'pool', 'plaster'),
(@prop_pete, 'Pool 5', 'pool', 'plaster');

INSERT INTO pools (property_id, label, pool_type, surface) VALUES
(@prop_michael, 'Main Pool', 'pool', 'tile'),
(@prop_michael, 'Spa Pool',  'spa',  'tile');

INSERT INTO pools (property_id, label, pool_type, surface) VALUES
(@prop_dwayne, 'Main Pool', 'pool', 'plaster');

INSERT INTO pools (property_id, label, pool_type, surface) VALUES
(@prop_sabrina, 'Main Pool', 'pool', 'tile'),
(@prop_sabrina, 'Lap Pool',  'pool', 'tile'),
(@prop_sabrina, 'Spa Pool',  'spa',  'tile');

INSERT INTO pools (property_id, label, pool_type, surface) VALUES
(@prop_jean_home,  'Main Pool', 'pool', 'plaster'),
(@prop_jean_beach, 'Main Pool', 'pool', 'plaster');

INSERT INTO pools (property_id, label, pool_type, surface) VALUES
(@prop_christian, 'Main Pool', 'pool', 'other');

SET @pools_martha    := (SELECT COUNT(*) FROM pools WHERE property_id=@prop_martha);
SET @pools_pete      := (SELECT COUNT(*) FROM pools WHERE property_id=@prop_pete);
SET @pools_michael   := (SELECT COUNT(*) FROM pools WHERE property_id=@prop_michael);
SET @pools_dwayne    := (SELECT COUNT(*) FROM pools WHERE property_id=@prop_dwayne);
SET @pools_sabrina   := (SELECT COUNT(*) FROM pools WHERE property_id=@prop_sabrina);
SET @pools_jean_home := (SELECT COUNT(*) FROM pools WHERE property_id=@prop_jean_home);
SET @pools_jean_beach:= (SELECT COUNT(*) FROM pools WHERE property_id=@prop_jean_beach);
SET @pools_christian := (SELECT COUNT(*) FROM pools WHERE property_id=@prop_christian);

INSERT INTO service_catalog (service_name, default_fee) VALUES
('Basic Maintenance (No Chemicals, No Filter)', 50.00),
('Chemical Maintenance (Chemicals Only)', 40.00),
('Filter Maintenance (Filter Only)', 20.00),
('Full Maintenance (All Included)', 100.00);

SET @svc_basic   := (SELECT service_id FROM service_catalog WHERE service_name='Basic Maintenance (No Chemicals, No Filter)');
SET @svc_chem    := (SELECT service_id FROM service_catalog WHERE service_name='Chemical Maintenance (Chemicals Only)');
SET @svc_filter  := (SELECT service_id FROM service_catalog WHERE service_name='Filter Maintenance (Filter Only)');
SET @svc_full    := (SELECT service_id FROM service_catalog WHERE service_name='Full Maintenance (All Included)');

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_martha, @tech_ektor, '2026-01-07', 'completed', 'Weekly visit');
SET @v_martha_1 := LAST_INSERT_ID();

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_pete, @tech_ektor, '2026-01-07', 'completed', 'Weekly visit');
SET @v_pete_1 := LAST_INSERT_ID();

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_michael, @tech_ektor, '2026-01-06', 'completed', 'Visit 1/2');
SET @v_michael_1 := LAST_INSERT_ID();

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_michael, @tech_ektor, '2026-01-09', 'completed', 'Visit 2/2');
SET @v_michael_2 := LAST_INSERT_ID();

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_dwayne, @tech_ektor, '2026-01-07', 'completed', 'Weekly visit');
SET @v_dwayne_1 := LAST_INSERT_ID();

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_sabrina, @tech_ektor, '2026-01-06', 'completed', 'Visit 1/2');
SET @v_sabrina_1 := LAST_INSERT_ID();

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_sabrina, @tech_ektor, '2026-01-09', 'completed', 'Visit 2/2');
SET @v_sabrina_2 := LAST_INSERT_ID();

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_jean_home, @tech_ektor, '2026-01-07', 'completed', 'Weekly visit');
SET @v_jean_home_1 := LAST_INSERT_ID();

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_jean_beach, @tech_ektor, '2026-01-07', 'completed', 'Weekly visit');
SET @v_jean_beach_1 := LAST_INSERT_ID();

INSERT INTO visits (property_id, technician_id, visit_date, status, notes)
VALUES (@prop_christian, @tech_ektor, '2026-01-07', 'completed', 'Weekly visit');
SET @v_christian_1 := LAST_INSERT_ID();

INSERT INTO visit_services (visit_id, service_id, quantity, fee, notes)
VALUES (@v_martha_1, @svc_full, @pools_martha, 100.00, 'Per pool');

INSERT INTO visit_services (visit_id, service_id, quantity, fee, notes)
VALUES (@v_pete_1, @svc_basic, @pools_pete, 50.00, 'Per pool');

INSERT INTO visit_services (visit_id, service_id, quantity, fee, notes)
VALUES
(@v_michael_1, @svc_full, @pools_michael, 100.00, 'Per pool'),
(@v_michael_2, @svc_full, @pools_michael, 100.00, 'Per pool');

INSERT INTO visit_services (visit_id, service_id, quantity, fee, notes)
VALUES
(@v_dwayne_1, @svc_basic,  @pools_dwayne, 50.00, 'Per pool'),
(@v_dwayne_1, @svc_filter, @pools_dwayne, 20.00, 'Per pool');

INSERT INTO visit_services (visit_id, service_id, quantity, fee, notes)
VALUES
(@v_sabrina_1, @svc_full, @pools_sabrina, 100.00, 'Per pool'),
(@v_sabrina_2, @svc_chem, @pools_sabrina, 40.00,  'Per pool');

INSERT INTO visit_services (visit_id, service_id, quantity, fee, notes)
VALUES
(@v_jean_home_1,  @svc_full, @pools_jean_home, 100.00, 'Per pool'),
(@v_jean_beach_1, @svc_full, @pools_jean_beach,100.00, 'Per pool');

INSERT INTO visit_services (visit_id, service_id, quantity, fee, notes)
VALUES
(@v_christian_1, @svc_chem,   @pools_christian, 40.00, 'Per pool'),
(@v_christian_1, @svc_filter, @pools_christian, 20.00, 'Per pool');

SET @period_start := '2026-01-05';
SET @period_end   := '2026-01-11';
SET @issued_date  := '2026-01-11';
SET @due_date     := '2026-01-18';

SET @sub := (
  SELECT IFNULL(SUM(vs.quantity * vs.fee),0)
  FROM visit_services vs
  JOIN visits v ON v.visit_id = vs.visit_id
  WHERE v.property_id=@prop_martha AND v.visit_date BETWEEN @period_start AND @period_end
);
INSERT INTO invoices (customer_id, property_id, period_start, period_end, status, issued_date, due_date, subtotal, tax, total, notes)
VALUES (@cust_martha, @prop_martha, @period_start, @period_end, 'sent', @issued_date, @due_date, @sub, 0.00, @sub, 'Weekly billing (per pool)');
SET @inv_martha := LAST_INSERT_ID();

INSERT INTO invoice_lines (invoice_id, description, quantity, unit_price, line_total)
SELECT @inv_martha, sc.service_name, SUM(vs.quantity), vs.fee, SUM(vs.quantity*vs.fee)
FROM visit_services vs
JOIN visits v ON v.visit_id=vs.visit_id
JOIN service_catalog sc ON sc.service_id=vs.service_id
WHERE v.property_id=@prop_martha AND v.visit_date BETWEEN @period_start AND @period_end
GROUP BY sc.service_name, vs.fee;

SET @sub := (
  SELECT IFNULL(SUM(vs.quantity * vs.fee),0)
  FROM visit_services vs JOIN visits v ON v.visit_id=vs.visit_id
  WHERE v.property_id=@prop_pete AND v.visit_date BETWEEN @period_start AND @period_end
);

INSERT INTO invoices (customer_id, property_id, period_start, period_end, status, issued_date, due_date, subtotal, tax, total, notes)
VALUES (@cust_pete, @prop_pete, @period_start, @period_end, 'sent', @issued_date, @due_date, @sub, 0.00, @sub, 'Weekly billing (per pool)');
SET @inv_pete := LAST_INSERT_ID();

INSERT INTO invoice_lines (invoice_id, description, quantity, unit_price, line_total)
SELECT @inv_pete, sc.service_name, SUM(vs.quantity), vs.fee, SUM(vs.quantity*vs.fee)
FROM visit_services vs
JOIN visits v ON v.visit_id=vs.visit_id
JOIN service_catalog sc ON sc.service_id=vs.service_id
WHERE v.property_id=@prop_pete AND v.visit_date BETWEEN @period_start AND @period_end
GROUP BY sc.service_name, vs.fee;

SET @sub := (
  SELECT IFNULL(SUM(vs.quantity * vs.fee),0)
  FROM visit_services vs JOIN visits v ON v.visit_id=vs.visit_id
  WHERE v.property_id=@prop_michael AND v.visit_date BETWEEN @period_start AND @period_end
);

INSERT INTO invoices (customer_id, property_id, period_start, period_end, status, issued_date, due_date, subtotal, tax, total, notes)
VALUES (@cust_michael, @prop_michael, @period_start, @period_end, 'sent', @issued_date, @due_date, @sub, 0.00, @sub, 'Weekly billing (per pool)');
SET @inv_michael := LAST_INSERT_ID();

INSERT INTO invoice_lines (invoice_id, description, quantity, unit_price, line_total)
SELECT @inv_michael, sc.service_name, SUM(vs.quantity), vs.fee, SUM(vs.quantity*vs.fee)
FROM visit_services vs
JOIN visits v ON v.visit_id=vs.visit_id
JOIN service_catalog sc ON sc.service_id=vs.service_id
WHERE v.property_id=@prop_michael AND v.visit_date BETWEEN @period_start AND @period_end
GROUP BY sc.service_name, vs.fee;

SET @sub := (
  SELECT IFNULL(SUM(vs.quantity * vs.fee),0)
  FROM visit_services vs JOIN visits v ON v.visit_id=vs.visit_id
  WHERE v.property_id=@prop_dwayne AND v.visit_date BETWEEN @period_start AND @period_end
);
INSERT INTO invoices (customer_id, property_id, period_start, period_end, status, issued_date, due_date, subtotal, tax, total, notes)
VALUES (@cust_dwayne, @prop_dwayne, @period_start, @period_end, 'sent', @issued_date, @due_date, @sub, 0.00, @sub, 'Weekly billing (per pool)');
SET @inv_dwayne := LAST_INSERT_ID();

INSERT INTO invoice_lines (invoice_id, description, quantity, unit_price, line_total)
SELECT @inv_dwayne, sc.service_name, SUM(vs.quantity), vs.fee, SUM(vs.quantity*vs.fee)
FROM visit_services vs
JOIN visits v ON v.visit_id=vs.visit_id
JOIN service_catalog sc ON sc.service_id=vs.service_id
WHERE v.property_id=@prop_dwayne AND v.visit_date BETWEEN @period_start AND @period_end
GROUP BY sc.service_name, vs.fee;

SET @sub := (
  SELECT IFNULL(SUM(vs.quantity * vs.fee),0)
  FROM visit_services vs JOIN visits v ON v.visit_id=vs.visit_id
  WHERE v.property_id=@prop_sabrina AND v.visit_date BETWEEN @period_start AND @period_end
);
INSERT INTO invoices (customer_id, property_id, period_start, period_end, status, issued_date, due_date, subtotal, tax, total, notes)
VALUES (@cust_sabrina, @prop_sabrina, @period_start, @period_end, 'sent', @issued_date, @due_date, @sub, 0.00, @sub, 'Weekly billing (per pool)');
SET @inv_sabrina := LAST_INSERT_ID();

INSERT INTO invoice_lines (invoice_id, description, quantity, unit_price, line_total)
SELECT @inv_sabrina, sc.service_name, SUM(vs.quantity), vs.fee, SUM(vs.quantity*vs.fee)
FROM visit_services vs
JOIN visits v ON v.visit_id=vs.visit_id
JOIN service_catalog sc ON sc.service_id=vs.service_id
WHERE v.property_id=@prop_sabrina AND v.visit_date BETWEEN @period_start AND @period_end
GROUP BY sc.service_name, vs.fee;

SET @sub := (
  SELECT IFNULL(SUM(vs.quantity * vs.fee),0)
  FROM visit_services vs JOIN visits v ON v.visit_id=vs.visit_id
  WHERE v.property_id=@prop_jean_home AND v.visit_date BETWEEN @period_start AND @period_end
);
INSERT INTO invoices (customer_id, property_id, period_start, period_end, status, issued_date, due_date, subtotal, tax, total, notes)
VALUES (@cust_jean, @prop_jean_home, @period_start, @period_end, 'sent', @issued_date, @due_date, @sub, 0.00, @sub, 'Weekly billing (per pool)');
SET @inv_jean_home := LAST_INSERT_ID();

INSERT INTO invoice_lines (invoice_id, description, quantity, unit_price, line_total)
SELECT @inv_jean_home, sc.service_name, SUM(vs.quantity), vs.fee, SUM(vs.quantity*vs.fee)
FROM visit_services vs
JOIN visits v ON v.visit_id=vs.visit_id
JOIN service_catalog sc ON sc.service_id=vs.service_id
WHERE v.property_id=@prop_jean_home AND v.visit_date BETWEEN @period_start AND @period_end
GROUP BY sc.service_name, vs.fee;

SET @sub := (
  SELECT IFNULL(SUM(vs.quantity * vs.fee),0)
  FROM visit_services vs JOIN visits v ON v.visit_id=vs.visit_id
  WHERE v.property_id=@prop_jean_beach AND v.visit_date BETWEEN @period_start AND @period_end
);
INSERT INTO invoices (customer_id, property_id, period_start, period_end, status, issued_date, due_date, subtotal, tax, total, notes)
VALUES (@cust_jean, @prop_jean_beach, @period_start, @period_end, 'sent', @issued_date, @due_date, @sub, 0.00, @sub, 'Weekly billing (per pool)');
SET @inv_jean_beach := LAST_INSERT_ID();

INSERT INTO invoice_lines (invoice_id, description, quantity, unit_price, line_total)
SELECT @inv_jean_beach, sc.service_name, SUM(vs.quantity), vs.fee, SUM(vs.quantity*vs.fee)
FROM visit_services vs
JOIN visits v ON v.visit_id=vs.visit_id
JOIN service_catalog sc ON sc.service_id=vs.service_id
WHERE v.property_id=@prop_jean_beach AND v.visit_date BETWEEN @period_start AND @period_end
GROUP BY sc.service_name, vs.fee;

SET @sub := (
  SELECT IFNULL(SUM(vs.quantity * vs.fee),0)
  FROM visit_services vs JOIN visits v ON v.visit_id=vs.visit_id
  WHERE v.property_id=@prop_christian AND v.visit_date BETWEEN @period_start AND @period_end
);
INSERT INTO invoices (customer_id, property_id, period_start, period_end, status, issued_date, due_date, subtotal, tax, total, notes)
VALUES (@cust_christian, @prop_christian, @period_start, @period_end, 'sent', @issued_date, @due_date, @sub, 0.00, @sub, 'Weekly billing (per pool)');
SET @inv_christian := LAST_INSERT_ID();

INSERT INTO invoice_lines (invoice_id, description, quantity, unit_price, line_total)
SELECT @inv_christian, sc.service_name, SUM(vs.quantity), vs.fee, SUM(vs.quantity*vs.fee)
FROM visit_services vs
JOIN visits v ON v.visit_id=vs.visit_id
JOIN service_catalog sc ON sc.service_id=vs.service_id
WHERE v.property_id=@prop_christian AND v.visit_date BETWEEN @period_start AND @period_end
GROUP BY sc.service_name, vs.fee;

INSERT INTO payments (invoice_id, paid_date, amount, method, reference, notes)
VALUES
(@inv_martha, '2026-01-11', (SELECT total FROM invoices WHERE invoice_id=@inv_martha), 'ath_movil', 'ATH-1001', 'Paid on delivery'),
(@inv_jean_home,'2026-01-12',(SELECT total FROM invoices WHERE invoice_id=@inv_jean_home),'cash','CASH-2001','Paid next day');

UPDATE invoices SET status='paid' WHERE invoice_id IN (@inv_martha, @inv_jean_home);