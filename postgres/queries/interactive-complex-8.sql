/* Q8. Recent replies
\set personId 17592186044461
 */
SELECT
    m1.CreatorPersonId,
    firstName,
    lastName,
    m1.creationDate,
    m1.MessageId,
    m1.content
FROM
    Message m1,
    Message m2,
    Person
WHERE m1.ParentMessageId = m2.MessageId
  AND m2.CreatorPersonId = :personId
  AND Person.Id = m1.CreatorPersonId
ORDER BY
    m1.creationDate DESC,
    m1.MessageId ASC
LIMIT 20
;
