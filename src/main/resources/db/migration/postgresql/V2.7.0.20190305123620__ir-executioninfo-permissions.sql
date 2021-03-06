ALTER TABLE ${ohdsiSchema}.sec_permission ADD for_role_id INTEGER;

INSERT INTO ${ohdsiSchema}.sec_permission (id, value, for_role_id)
  SELECT nextval('${ohdsiSchema}.sec_permission_id_seq'), REPLACE(CAST(new_perms.val AS VARCHAR), '%s', REPLACE(REPLACE(value, 'source:', ''), ':access', '')), role_id
FROM ${ohdsiSchema}.sec_permission sp
JOIN ${ohdsiSchema}.sec_role_permission srp on sp.id = srp.permission_id
CROSS JOIN (
  SELECT 'ir:*:info:%s:get' val
) new_perms
WHERE sp.value LIKE 'source:%:access';

INSERT INTO ${ohdsiSchema}.sec_role_permission (id, role_id, permission_id)
  SELECT nextval('${ohdsiSchema}.sec_role_permission_sequence'), sp.for_role_id, sp.id
FROM ${ohdsiSchema}.sec_permission sp
WHERE sp.for_role_id IS NOT NULL;

ALTER TABLE ${ohdsiSchema}.sec_permission DROP COLUMN for_role_id;