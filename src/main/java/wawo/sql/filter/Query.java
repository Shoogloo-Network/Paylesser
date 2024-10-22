//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.filter;

import wawo.sql.DataBaseException;
import wawo.sql.Database;

public class Query {
    public int TYPE_SCROLL;
    public String mainQuery;
    public Object[] mainQueryParams;
    public Class mainReturnClass;
    public String countQuery;
    public Object[] countQueryParams;
    private StringBuffer sortQuery;
    private StringBuffer searchQuery;
    private QueryFilter queryFilter;
    private Database database;

    public Query() {
        this(Database.POSTGRES);
    }

    public Query(Database database) {
        this.TYPE_SCROLL = 1003;
        this.mainQuery = null;
        this.mainQueryParams = null;
        this.mainReturnClass = null;
        this.countQuery = null;
        this.countQueryParams = null;
        this.sortQuery = null;
        this.searchQuery = null;
        this.queryFilter = null;
        this.database = database;
    }

    public void appendSort(String sortString) {
        if (this.sortQuery == null) {
            this.sortQuery = new StringBuffer();
        }

        this.sortQuery.append(sortString);
    }

    public void appendSearch(String searchString) {
        if (this.searchQuery == null) {
            this.searchQuery = new StringBuffer();
        }

        this.searchQuery.append(searchString);
    }

    public void formatSearchSort(Format format) {
        FormatSearchSort.buildSearchSort(this, format, true);
    }

    public void formatSearchSortSql(Format format) {
        FormatSearchSort.buildSearchSort(this, format, false);
    }

    public String getFinalMainQuery() {
        return this.formatQuery(this.mainQuery, true);
    }

    public String getFinalCountQuery() {
        if (this.countQuery == null) {
            this.countQuery = FilterUtil.formatToRecordCountQuery(this.mainQuery);
        }

        if (this.countQueryParams == null) {
            this.countQueryParams = this.mainQueryParams;
        }

        return this.formatQuery(this.countQuery, false);
    }

    private String formatQuery(String query, boolean hasSort) {
        StringBuilder sb = new StringBuilder();
        sb.append(query);
        if (this.searchQuery != null) {
            sb.append(this.searchQuery.toString());
        }

        if (this.sortQuery != null && hasSort) {
            sb.append(this.sortQuery.toString());
        }

        return sb.toString();
    }

    public String getFinalLazyQuery() {
        if (this.queryFilter == null) {
            throw new DataBaseException("QueryFilter is null. QueryFilter is required to filter data");
        } else {
            Long from = this.queryFilter.getFetchStart();
            Long end = this.queryFilter.getFetchEnd();
            if (this.database != Database.POSTGRES && this.database != Database.MYSQL) {
                if (this.database == Database.ORACLE) {
                    from = from + 1L;
                    return "SELECT * FROM (SELECT WAWO.*,rownum WAWO_NO FROM (" + this.formatQuery(this.mainQuery, true) + ") WAWO WHERE rownum <= " + end + ") WHERE WAWO_NO >=" + from;
                } else {
                    return this.database == Database.DERBY ? this.formatQuery(this.mainQuery, true) + " OFFSET " + from + " ROWS FETCH NEXT " + end + " ROWS ONLY" : this.formatQuery(this.mainQuery, true);
                }
            } else {
                end = end + 1L;
                return this.formatQuery(this.mainQuery, true) + " LIMIT " + end + " OFFSET " + from;
            }
        }
    }

    public void setQueryFilter(QueryFilter queryFilter) {
        this.queryFilter = queryFilter;
    }

    public void setDatabase(Database database) {
        this.database = database;
    }

    public QueryFilter getQueryFilter() {
        if (this.queryFilter == null) {
            this.queryFilter = new QueryFilter();
        }

        return this.queryFilter;
    }

    public Database getDatabase() {
        return this.database;
    }
}
