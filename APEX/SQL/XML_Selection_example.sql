SELECT XMLELEMENT("Task", XMLATTRIBUTES (p.teilprojekt_name as "Stream", p.task_title as "DESC"), XMLELEMENT("Status", p.status), XMLELEMENT("Startdate", p.startdate))
FROM psp_items p