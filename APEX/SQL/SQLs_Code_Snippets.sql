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