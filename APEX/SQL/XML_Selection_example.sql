SELECT XMLELEMENT("Task", XMLATTRIBUTES (p.teilprojekt_name as "Stream", p.task_title as "DESC"), XMLELEMENT("Status", p.status), XMLELEMENT("Startdate", p.startdate))
FROM psp_items p

-- select xml_toat
select XMLELEMENT("TEMPLATE", XMLATTRIBUTES (ci.key as "name", 'false' as "advanced"), XMLELEMENT("DESCCRIPTION", s.name), XMLELEMENT("CODE", s.code))
from   cs_coll_item ci
join   cs_snippets s on s.id = ci.snip_id
where  ci.coll_id = 3


-- select von SQL-Developper
    with xmlcontent
    as (
    select 
    XMLType(content, 1) as XMLT
    from   cs_file_contents
    where  id = 37)
    SELECT xt.*
    FROM   xmlcontent x,
           XMLTABLE('/rows/row'
             PASSING x.xmlt
             COLUMNS 
               key       VARCHAR2(50) PATH 'key',
               value     VARCHAR2(2000) PATH 'value'
             ) xt;

-- select vn TAOD XML format
    with xmlcontent
    as (
    select 
    XMLType(content, 1) as XMLT
    from   cs_file_contents
    where  id = 38)
    SELECT xt.*
    FROM   xmlcontent x,
           XMLTABLE('/TEMPLATES/TEMPLATE'
             PASSING x.xmlt
             COLUMNS
               DESCN      VARCHAR2(200) PATH 'DESCRIPTION'
              ,NAMEN      VARCHAR2(50)  PATH '@name'
              ,CODES      VARCHAR2(2000) PATH 'CODE'
              ,ADV        VARCHAR2(30) PATH '@advanced'
             ) xt;