INSERT INTO Message_hasTag_Tag (
    creationDate
  , MessageId
  , TagId
)
SELECT :creationDate, :commentId, unnest(:tagIds);
