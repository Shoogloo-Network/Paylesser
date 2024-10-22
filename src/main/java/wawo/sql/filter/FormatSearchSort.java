//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.filter;

import java.lang.annotation.Annotation;
import java.lang.annotation.AnnotationFormatError;
//import javax.persistence.Column;
import wawo.sql.Database;
import wawo.sql.SqlEscape;
import wawo.sql.schema.Column;
import wawo.sql.schema.Field;
import wawo.util.StringUtil;

abstract class FormatSearchSort {
    private FormatSearchSort() {
    }

    private static Field[] formatField(Format format, String[] fields) {
        if (fields != null && fields.length > 0) {
            Field[] fs = new Field[fields.length];
            int i = 0;
            Field f = null;
            if (format == null) {
                format = new Format();
            }

            String[] var5 = fields;
            int var6 = fields.length;

            for(int var7 = 0; var7 < var6; ++var7) {
                String column = var5[var7];
                if (format.getColumnFormatterMap() != null) {
                    f = (Field)format.getColumnFormatterMap().get(column);
                    if (f == null) {
                        f = (Field)format.getColumnFormatterMap().get(column.toLowerCase());
                    }

                    if (f == null) {
                        f = (Field)format.getColumnFormatterMap().get(column.toUpperCase());
                    }
                }

                if (f == null) {
                    if (column.contains(".")) {
                        String[] s = column.split("\\.");
                        fs[i] = new Field(s[0], s[1]);
                    } else {
                        fs[i] = new Field(format.getDefaultAlias(), column);
                    }
                } else {
                    fs[i] = f;
                }

                ++i;
            }

            return fs;
        } else {
            return null;
        }
    }

    private static String getColumnName(Class classz, String javaField) {
        try {
            java.lang.reflect.Field field;
            if (javaField.contains(".")) {
                String[] s = javaField.split("\\.");
                field = classz.getDeclaredField(s[0]);
                javaField = s[1];
                classz = field.getType();
            }

            field = classz.getDeclaredField(javaField);
            Annotation[] var10 = field.getDeclaredAnnotations();
            int var4 = var10.length;

            for(int var5 = 0; var5 < var4; ++var5) {
                Annotation a = var10[var5];
                if (a instanceof Column) {
                    Column ca = (Column) a;
                  //  return ca.name().replaceAll("\"", "");
                }
            }
        } catch (SecurityException | NoSuchFieldException var8) {
            Exception ex = var8;
            throw new AnnotationFormatError("Error processing annotation for field [" + javaField + "] \n Use @Column(name=\"<actual column name>\")\nClass=" + classz, ex);
        }

        throw new AnnotationFormatError("No annotation or field found. Given field [" + javaField + "] \n Use @Column(name=\"<actual column name>\")\nClass=" + classz);
    }

    protected static void buildSearchSort(Query query, Format sqlField, boolean isEntity) {
        if (query.mainReturnClass == null) {
            throw new NullPointerException("query.returnClass is null, it is required for buildSearchSortEntity");
        } else {
            QueryFilter qf = query.getQueryFilter();
            buildSearchQuery(query, formatField(sqlField, qf.getSearchFieldsArray()));
            if (qf.getSortField() != null) {
                if (isEntity) {
                    buildSortQuery(query, formatField(sqlField, new String[]{getColumnName(query.mainReturnClass, qf.getSortField())}));
                } else {
                    buildSortQuery(query, formatField(sqlField, new String[]{qf.getSortField()}));
                }
            }

        }
    }

    private static String removeOrderBy(String query) {
        String field = query.toUpperCase();
        int orderBy = field.lastIndexOf("ORDER BY");
        return orderBy != -1 ? query.substring(0, orderBy) : query;
    }

    private static void buildSortQuery(Query query, Field[] fields) {
        if (!StringUtil.isEmpty(query.getQueryFilter().getSortField())) {
            query.mainQuery = removeOrderBy(query.mainQuery);
            query.appendSort(" ORDER BY ");
            Field field = fields[0];
            if (field.isStringFamily()) {
                query.appendSort("UPPER(" + field.getQueryField() + ") ");
            } else {
                query.appendSort(field.getQueryField());
            }

            query.appendSort(" ");
            query.appendSort(query.getQueryFilter().getSortBy());
        }
    }

    private static void buildSearchQuery(Query query, Field[] fields) {
        QueryFilter qf = query.getQueryFilter();
        if (!StringUtil.isEmpty(qf.getSearchCriteria())) {
            if (fields != null && fields.length > 0) {
                String searchString = SqlEscape.parse(qf.getSearchCriteria(), query.getDatabase());
                query.mainQuery = removeOrderBy(query.mainQuery);
                String upperQuery = query.mainQuery.toUpperCase();
                if (!upperQuery.contains(" WHERE ")) {
                    query.appendSearch(" WHERE 1=1 ");
                }

                query.appendSearch(" AND (");
                String searchOperator = " OR ";
                if ("ALL".equals(qf.getSearchMatch()) || "ALL_EXACT".equals(qf.getSearchMatch())) {
                    searchOperator = " AND";
                }

                searchString = searchString.toUpperCase();
                int i = 0;
                int len = fields.length;
                Field[] var8 = fields;
                int var9 = fields.length;

                for(int var10 = 0; var10 < var9; ++var10) {
                    Field f = var8[var10];
                    ++i;
                    if (f.isStringFamily()) {
                        query.appendSearch(" UPPER(" + f.getQueryField() + ") ");
                    } else {
                        query.appendSearch(f.getQueryField());
                    }

                    if (qf.getSearchMatch() == null) {
                        qf.setSearchMatch("ANY");
                    }

                    if (null != qf.getSearchMatch()) {
                        switch (qf.getSearchMatch()) {
                            case "ALL":
                            case "ANY":
                                query.appendSearch(" LIKE '%" + searchString + "%'");
                                break;
                            case "ALL_EXACT":
                            case "ANY_EXACT":
                                query.appendSearch(" LIKE '" + searchString + "'");
                                break;
                            case "EQUAL_NUMBER":
                                query.appendSearch(" = " + searchString);
                                break;
                            case "EQUAL_STRING":
                                query.appendSearch(" = '" + searchString + "'");
                                break;
                            default:
                                query.appendSearch(" LIKE '%" + searchString + "%'");
                        }
                    }

                    if (Database.ORACLE == query.getDatabase()) {
                        query.appendSearch(" ESCAPE '\\'");
                    }

                    if (i < len) {
                        query.appendSearch(searchOperator);
                    }
                }

                query.appendSearch(") ");
            }
        }
    }
}
