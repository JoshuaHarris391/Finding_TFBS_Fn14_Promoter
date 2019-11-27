
/* Creating Variable tables */
CREATE TABLE family AS SELECT MATRIX_ANNOTATION.ID, val AS family_val FROM MATRIX_ANNOTATION WHERE TAG = "family";
CREATE TABLE source AS  SELECT MATRIX_ANNOTATION.ID, val AS source_val FROM MATRIX_ANNOTATION WHERE TAG = "source";
CREATE TABLE medline AS  SELECT MATRIX_ANNOTATION.ID, val AS medline_val FROM MATRIX_ANNOTATION WHERE TAG = "medline";
CREATE TABLE type AS  SELECT MATRIX_ANNOTATION.ID, val AS type_val FROM MATRIX_ANNOTATION WHERE TAG = "type";
CREATE TABLE description AS  SELECT MATRIX_ANNOTATION.ID, val AS description_val FROM MATRIX_ANNOTATION WHERE TAG = "description";
CREATE TABLE tf_class AS  SELECT MATRIX_ANNOTATION.ID, val AS class_val FROM MATRIX_ANNOTATION WHERE TAG = "class";
CREATE TABLE consensus AS  SELECT MATRIX_ANNOTATION.ID, val AS consensus_val FROM MATRIX_ANNOTATION WHERE TAG = "consensus";
CREATE TABLE comment AS  SELECT MATRIX_ANNOTATION.ID, val AS comment_val FROM MATRIX_ANNOTATION WHERE TAG = "comment";


/* Querying Table */
SELECT MATRIX.ID, COLLECTION, BASE_ID, name, TAX_ID, family_val AS 'FAMILY', source_val AS 'SOURCE', medline_val AS 'MEDLINE', type_val AS 'TYPE', description_val AS 'DESCRIPTION', class_val AS 'CLASS', consensus_val AS 'CONSENSUS', comment_val AS 'COMMENT'
FROM MATRIX
INNER JOIN MATRIX_ANNOTATION
ON MATRIX.ID = MATRIX_ANNOTATION.ID
INNER JOIN MATRIX_SPECIES
ON MATRIX.ID = MATRIX_SPECIES.ID
LEFT OUTER JOIN family
ON MATRIX.ID = family.ID
LEFT OUTER JOIN source
ON MATRIX.ID = source.ID
LEFT OUTER JOIN medline
ON MATRIX.ID = medline.ID
LEFT OUTER JOIN type
ON MATRIX.ID = type.ID
LEFT OUTER JOIN description
ON MATRIX.ID = description.ID
LEFT OUTER JOIN tf_class
ON MATRIX.ID = tf_class.ID
LEFT OUTER JOIN consensus
ON MATRIX.ID = consensus.ID
LEFT OUTER JOIN comment
ON MATRIX.ID = comment.ID
WHERE TAX_ID = "9606";