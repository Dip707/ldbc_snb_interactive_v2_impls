SELECT TOP(10) p_personid, p_firstname, p_lastname,( 
  SELECT count(DISTINCT m_messageid)
    FROM message, message_tag pt1
   WHERE m_creatorid = p_personid 
     AND m_c_replyof IS NULL
     AND m_messageid = mt_messageid 
     AND EXISTS (
       SELECT * 
         FROM person_tag
        WHERE pt_personid = :personId 
          AND pt_tagid = pt1.mt_tagid
     )
) -
( SELECT count(*)
    FROM message
   WHERE m_creatorid = p_personid
     AND m_c_replyof IS NULL 
     AND NOT EXISTS (
       SELECT * 
         FROM person_tag, message_tag
        WHERE pt_personid = :personId
          AND pt_tagid = mt_tagid 
          AND mt_messageid = m_messageid
     )
) AS score, p_gender, pl_name
FROM person, place,(
  SELECT DISTINCT k2.k_person2id
    FROM knows k1, knows k2
   WHERE k1.k_person1id = :personId 
     AND k1.k_person2id = k2.k_person1id 
     AND k2.k_person2id <> :personId 
     AND NOT EXISTS (
       SELECT * 
         FROM knows
        WHERE k_person1id = :personId
          AND k_person2id = k2.k_person2id
     )
) f
WHERE (
  p_placeid = pl_placeid
  AND p_personid = f.k_person2id
  AND MONTH(p_birthday) = :month
  AND DAY(p_birthday) >= 21
OR 
  p_placeid = pl_placeid 
  AND p_personid = f.k_person2id 
  AND MONTH(p_birthday) = (:month % 12 + 1) 
  AND DAY(p_birthday) <  22
)
ORDER BY score DESC, p_personid;
