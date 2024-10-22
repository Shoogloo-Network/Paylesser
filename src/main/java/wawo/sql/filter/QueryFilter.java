//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package wawo.sql.filter;

public class QueryFilter {
    private static final String SEP = ",";
    private Long fetchStart = null;
    private Long fetchLimit = null;
    private int fetchRows = 15;
    private Long totalRecords = null;
    private String sortField;
    private String sortBy = "ASC";
    private String searchFields;
    private String searchCriteria;
    private String searchMatch;

    public QueryFilter() {
    }

    public void setFetchRows(int fetchRows) {
        this.fetchRows = fetchRows;
    }

    public void setSortField(String sortField) {
        this.sortField = sortField;
    }

    public void setSortBy(String sortBy) {
        this.sortBy = sortBy;
    }

    public void setSearchFields(String searchFields) {
        this.searchFields = searchFields;
    }

    public void setSearchFieldsIfEmpty(String searchFields) {
        if ((this.searchFields == null || this.searchFields.isEmpty()) && this.getSearchCriteria() != null && !this.getSearchCriteria().isEmpty()) {
            this.searchFields = searchFields;
        }

    }

    public void addToSearchFields(String searchFields) {
        if (this.searchFields != null && !this.searchFields.isEmpty()) {
            this.searchFields = this.searchFields + "," + searchFields;
        } else {
            this.searchFields = searchFields;
        }

    }

    public void setSearchCriteria(String searchCriteria) {
        if (searchCriteria != null) {
            searchCriteria = searchCriteria.trim();
        }

        this.searchCriteria = searchCriteria;
    }

    public void setSearchMatch(String searchMatch) {
        this.searchMatch = searchMatch;
    }

    public void setTotalRecords(Long totalRecords) {
        this.totalRecords = totalRecords;
    }

    public void setFetchLimit(Long fetchLimit) {
        this.fetchLimit = fetchLimit;
    }

    public void setFetchStart(Long fetchStart) {
        this.fetchStart = fetchStart;
    }

    public int getFetchRows() {
        return this.fetchRows;
    }

    public String getSortField() {
        return this.sortField;
    }

    public String getSortBy() {
        return this.sortBy;
    }

    public String getSearchFields() {
        return this.searchFields;
    }

    public String[] getSearchFieldsArray() {
        String searchField = this.getSearchFields();
        return searchField == null ? null : searchField.split(",");
    }

    public String getSearchCriteria() {
        return this.searchCriteria;
    }

    public String getSearchMatch() {
        return this.searchMatch;
    }

    public Long getTotalRecords() {
        return this.totalRecords;
    }

    public Long getFetchStart() {
        return this.fetchStart != null ? this.fetchStart : Long.valueOf("0");
    }

    public Long getFetchEnd() {
        return this.getFetchStart() + this.getFetchLimit();
    }

    public Long getFetchLimit() {
        if (this.fetchLimit == null) {
            this.fetchLimit = (long)this.fetchRows;
        }

        return this.fetchLimit;
    }

    public void clearSearch() {
        this.searchCriteria = null;
        this.searchFields = null;
        this.searchMatch = null;
    }
}
