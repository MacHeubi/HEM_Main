-- All Collections and items for user
select  c.name           as COLLETION_NAME
       ,c.DESCRIPTION    as COLLECTION_DESC
       ,c.INSERT_DATE    as COLLECTION_INS_DATE
       ,c.OWNER          as COLLECTION_OWNER
       ,c.PRIVATE        as COLLECTION_PRIVAT
       ,ci.KEY           as SNIP_KEY
       ,s.NAME           as SNIP_NAME
       ,s.DESCRIPTION    as SNIP_DESC
       ,g.NAME           as SNIP_GROUP
       ,s.CODE           as SNIP_CODE
       ,s.INSERT_DATE    as SNIP_INS_DATE
       ,s.OWNER          as SNIP_OWNER
       ,s.PRIVAT         as SNIP_PRIVAT
       ,g.DESCRIPTION    as GROUP_DESC
from   CS_COLL_ITEM ci
join   CS_SNIPPETS s on s.id = ci.SNIP_ID
join   CS_COLLECTIONS c on c.id = ci.COLL_ID
join   CS_GROUP g on g.id = s.group_id
where  c.OWNER = 'HEM'
and    c.id = 2

-- Collection data per user
select  c.name           as COLLETION_NAME
       ,c.DESCRIPTION    as COLLECTION_DESC
       ,c.INSERT_DATE    as COLLECTION_INS_DATE
       ,c.OWNER           as COLLECTION_OWNER
       ,c.PRIVATE         as COLLECTION_PRIVAT
       ,(select count(*) from CS_COLL_ITEM ci where c.id = ci.COLL_ID) as CNT_ITEM
       ,(select count(key) - count(distinct key) from CS_COLL_ITEM ci where c.id = ci.COLL_ID) as CNT_DUPL
       ,(select count(*) from CS_COLL_ITEM ci where c.id = ci.COLL_ID and ci.key is null) as CNT_NO_KEY
from   CS_COLLECTIONS c
where  c.OWNER = 'HEM'-- input parameter: User e.g. 'hem'

-- Load snippets from loader csv
INSERT INTO cs_snippets
  (name, Description, code, advanced, privat, insert_date, OWNER)
select  NVL(substr(l.description,1,79),'PLEASE PROVIDE A NAME'),
        l.description,
        l.value,
        case l.advanced when 'false' then 0 else 1 end case,
        0,
        sysdate,
        'TSR'
from    cs_snip_loader_tsr l

-- Insert a collection
INSERT INTO cs_collections
  (name, Description, private, insert_date, OWNER)
select  'My Collection (generated)',
        'My default Collection upon Login (generated)',
        0,
        sysdate,
        'TSR'
from    dual

-- Insert into coll_items for a collection (tsr=1, hem=2)
INSERT INTO cs_coll_item
  (coll_id, snip_id, key)
select 1,
        l.id,
        l.key
from   cs_snip_loader_tsr l
join   cs_snippets s on s.code = l.value

-- Insert into coll_items for a small test collection (tsr=1, hem=2)
INSERT INTO cs_coll_item
  (coll_id, snip_id, key)
select 3,
        l.id,
        l.key
from   cs_snip_loader_tsr l
join   cs_snippets s on s.code = l.value
where  rownum < 5

-- set a group ID for all snippets (default -> to be cleansed)
update cs_snippets set group_id = 3

-- Create an URL with fuction in APEX
  , apex_page.get_url(
        p_page => '19'
      , p_items => 'P19_ID'
      , p_values => id)   as  card_link

-- Wott eifach nöt !!!! diä Liste dynamisch füllen
select  s.NAME           as SNIP_NAME
       ,s.DESCRIPTION    as SNIP_DESC
       ,ci.KEY           as SNIP_KEY
       ,s.CODE           as SNIP_CODE
       ,g.DESCRIPTION    as GROUP_DESC
       ,s.INSERT_DATE    as SNIP_INS_DATE
       ,s.PRIVAT         as SNIP_PRIVAT
from   CS_COLL_ITEM ci
join   CS_SNIPPETS s on s.id = ci.SNIP_ID
join   CS_COLLECTIONS c on c.id = ci.COLL_ID
join   CS_GROUP g on g.id = s.group_id
where  upper(c.OWNER) = upper('&APP_USER.')
and    c.id = 3--nvl(&ACTIV_COLL_ID,0)
order by SNIP_INS_DATE desc

--  Detail view for master detail

create or replace view SNIP_DETAIL as
select ci.coll_id        as COLL_ID
       ,ci.id            as COLL_ITEM_ID
       ,ci.KEY           as SNIP_KEY
       ,s.ID             as SNIP_ID 
       ,s.NAME           as SNIP_NAME
       ,s.DESCRIPTION    as SNIP_DESC
       ,s.CODE           as SNIP_CODE
       ,g.ID             as GROUP_ID
       ,g.DESCRIPTION    as GROUP_DESC
       ,s.INSERT_DATE    as SNIP_INS_DATE
       ,s.PRIVATE        as SNIP_PRIVATE
       ,s.OWNER          as SNIP_OWNER
from   CS_COLL_ITEM ci
join   CS_SNIPPETS s on s.id = ci.SNIP_ID
join   CS_GROUP g on g.id = s.group_id

--  Detail view for Collection API Page
create or replace view CS_COLLECTION_DETAIL_V as
select  c.id             as COLL_ID
       ,c.name           as COLL_NAME
       ,c.description    as COLL_DESC
       ,c.private        as COLL_PRIVATE
       ,c.insert_date    as COLL_INSDATE
       ,c.owner          as COLL_OWNER
       ,(select count(*) from cs_coll_item ci where ci.coll_id = c.id)  as SNIP_COUNT
       ,(select count(key) - count(distinct key) from CS_COLL_ITEM ci where c.id = ci.COLL_ID) as CNT_DUPL_KEY
       ,(select count(*) from CS_COLL_ITEM ci where c.id = ci.COLL_ID and ci.key is null) as CNT_NO_KEY
from   CS_COLLECTIONS c

-- Create file content table
CREATE TABLE  "CS_FILE_CONTENTS"
   ("ID" NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE, 
	  "SUBJECT"   VARCHAR2(80) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,
    "FILE_NAME" VARCHAR2(50) COLLATE "USING_NLS_COMP" NOT NULL ENABLE, 
    "TOOL_MIME_TYPE" VARCHAR2 (100) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,
    "OWNER"     VARCHAR2(50) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,
    "INS_DATE"  DATE NOT NULL ENABLE,
    "COLL_ID"   NUMBER,
    "CONTENT"   CLOB,
	 PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP"

-- Procedure to copy a snippet to a collection
CREATE OR REPLACE PROCEDURE CS_P_MOVE_COLL_ITEM_TO_COLL
(
	   p_coll_id IN cs_collections.ID%TYPE,
	   p_coll_item_id IN cs_coll_item.id%TYPE,
       p_user IN cs_collections.owner%TYPE)
is
    v_snip_root_id      cs_snippets.ID%TYPE;
    v_key_root          cs_coll_item.KEY%TYPE;
    v_snip_row          cs_snippets%ROWTYPE;
    v_owner             cs_collections.owner%TYPE;
    v_new_snip_id       cs_snippets.ID%TYPE;
    v_new_coll_item_id  cs_coll_item.ID%TYPE;
Begin

    -- Select root snippet id
    select snip_id, key
    into   v_snip_root_id, v_key_root
    from   cs_coll_item c
    where  c.id = p_coll_item_id;

    -- Select root snippet data
    select *
    into   v_snip_row
    from   cs_snippets s
    where  s.id = v_snip_root_id;
 
    -- select collection owner
    select Upper(owner)
    into   v_owner
    from   cs_collections c
    where  c.id = p_coll_id;

    -- Check owner of collection
    If v_owner = p_user then
      
        -- Create new snippet based on root
        v_new_snip_id := "K"."ISEQ$$_179127".nextval;

        INSERT INTO cs_snippets
          (ID, name, Description, code, group_id, advanced, private, insert_date, OWNER)
          Values
          (v_new_snip_id,
           v_snip_row.name,
           v_snip_row.description,
           v_snip_row.code,
           v_snip_row.group_id,
           v_snip_row.advanced,
           1,
           sysdate,
           p_user);

        -- create new collection_item entry
        v_new_coll_item_id := "K"."ISEQ$$_179121".nextval;

        INSERT INTO cs_coll_item
          (ID, COLL_ID, SNIP_ID, KEY)
          Values
          (v_new_coll_item_id,
           p_coll_id,
           v_new_snip_id,
           v_key_root);

        -- commit
        commit;

    end if;

end;

--  procedure to create insert contents
CREATE OR REPLACE PROCEDURE CS_P_CREATE_FILE_CONTENT
(
	   p_coll_id IN cs_collections.ID%TYPE,
	   p_subject IN cs_file_contents.SUBJECT%TYPE,
	   p_filename IN cs_file_contents.FILE_NAME%TYPE,
       p_tool_mime_type IN cs_file_contents.TOOL_MIME_TYPE%TYPE,
       p_user IN cs_collections.owner%TYPE)
is
    v_content           cs_file_contents.CONTENT%TYPE;
    v_temp_clob         cs_file_contents.CONTENT%TYPE;
    -- Cursor declaration
    CURSOR c_elements (in_coll_id cs_collections.ID%TYPE)
    IS
        select XMLELEMENT("TEMPLATE", XMLATTRIBUTES (ci.key as "name", 'false' as "advanced"), XMLELEMENT("DESCCRIPTION", s.name), XMLELEMENT("CODE", s.code)) as line
        from   cs_coll_item ci
        join   cs_snippets s on s.id = ci.snip_id
        where  ci.coll_id = in_coll_id
        order by ci.key;
    r_line c_elements%rowtype;
        
Begin

    -- Check TOOL_MIME_TYPE
    If p_tool_mime_type = 'TOAD-XML' then
        v_content := '<TEMPLATES>' || chr(13);
        -- Select the content into CLOB

        OPEN c_elements(p_coll_id);
        LOOP
            FETCH c_elements INTO r_line;
            -- Append to content
            v_temp_clob := r_line.line.getStringVal();
            v_content := v_content || v_temp_clob || chr(13);

            EXIT WHEN c_elements%notfound;
        END LOOP;
        v_content := v_content || '</TEMPLATES>';
        CLOSE c_elements;

        -- Create new CONTENT / Insert into Content Table
        INSERT INTO cs_file_contents
          (subject, file_name, tool_mime_type, OWNER, ins_date, coll_id, content)
          Values
          (p_subject,
           p_filename,
           p_tool_mime_type,
           p_user,
           sysdate,
           p_coll_id,
           v_content);

        -- commit
        commit;

    end if;

end;

--- create log table
CREATE TABLE  "CS_LOG"
   ("LOG_ITEM"   VARCHAR2(50) COLLATE "USING_NLS_COMP" NOT NULL ENABLE,
    "LOG_DESC"   VARCHAR2(4000) COLLATE "USING_NLS_COMP" NOT NULL ENABLE 
   )

-- insert into log table
           INSERT INTO cs_log
          (LOG_ITEM, LOG_DESC)
          Values
          ('Was',
           'Wieso');

-- lies das log
select *
from   cs_log

-- lösch das log
delete from cs_log

-- Try to read the XML data in the BLOB-Column
        SELECT XMLTYPE (UTL_RAW.cast_to_varchar2 (c.content)).EXTRACT('rows/row/value/text()') XMLValue, XMLTYPE (UTL_RAW.cast_to_varchar2 (c.content)).EXTRACT('rows/row/key/text()') XMLKey, c.*
  FROM cs_file_contents c