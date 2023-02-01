SELECT XMLELEMENT("Task", XMLATTRIBUTES (p.teilprojekt_name as "Stream", p.task_title as "DESC"), XMLELEMENT("Status", p.status), XMLELEMENT("Startdate", p.startdate))
FROM psp_items p

-- select xml_toat
select XMLELEMENT("TEMPLATE", XMLATTRIBUTES (ci.key as "name", 'false' as "advanced"), XMLELEMENT("DESCCRIPTION", s.name), XMLELEMENT("CODE", s.code))
from   cs_coll_item ci
join   cs_snippets s on s.id = ci.snip_id
where  ci.coll_id = 3