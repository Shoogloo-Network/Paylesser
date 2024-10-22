//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.filter;

abstract class FilterUtil {
    protected static String formatToRecordCountQuery(String query) {
        String queryUpper = query.toUpperCase();
        if (queryUpper.indexOf("COUNT(") != -1) {
            return query;
        } else {
            String restQuery = query.substring(queryUpper.lastIndexOf("FROM"), queryUpper.length());
            query = "SELECT COUNT(" + getFirstField(query) + ") " + removeOrderBy(restQuery);
            return query;
        }
    }

    private static String getFirstField(String query) {
        String queryUpper = query.toUpperCase();
        int commaIndex = queryUpper.indexOf(44);
        int fromIndex = queryUpper.indexOf("FROM");
        int asIndex = queryUpper.indexOf("AS");
        int index = -1;
        if (asIndex == -1) {
            index = commaIndex;
        } else if (commaIndex == -1 && asIndex < fromIndex) {
            index = asIndex;
        } else if (asIndex < commaIndex && asIndex < fromIndex) {
            index = asIndex;
        }

        if (index == -1 && commaIndex == -1) {
            index = fromIndex;
        } else if (index == -1) {
            if (commaIndex < asIndex && commaIndex < fromIndex) {
                index = commaIndex;
            } else {
                index = fromIndex;
            }
        }

        queryUpper = query.substring(queryUpper.indexOf("SELECT") + 6, index);
        return queryUpper;
    }

    private static String removeOrderBy(String query) {
        String queryUpper = query.toUpperCase();
        int orderBy = queryUpper.lastIndexOf("ORDER BY");
        return orderBy != -1 ? query.substring(0, orderBy) : query;
    }

    private FilterUtil() {
    }
}
