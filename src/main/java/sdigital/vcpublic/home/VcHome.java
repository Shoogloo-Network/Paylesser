//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.home;

import com.google.gson.Gson;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import sdigital.pl.products.domains.Product;
import sdigital.pl.products.domains.ProductBrand;
import sdigital.pl.products.domains.ProductCategory;
import sdigital.vcpublic.config.SystemConstant;
import sdigital.vcpublic.db.Connect;
import wawo.sql.jdbc.Db;

public class VcHome {
    private static VcHome vcHome = new VcHome();
    private static Map<String, String> domainUrlMap = new HashMap();
    private static Map<String, String> domainGrpMap = new HashMap();
    private static Map<String, List<Domains>> domainsListMap = new HashMap();
    private static Map<String, List<Language>> languageListMap = new HashMap();
    private static Map<String, Properties> labelsMap = new HashMap();
    private static Map<String, HomeConfig> configMap = new HashMap();
    private static Map<String, List<SeoUrl>> seoUrlMapByDomain = new HashMap();
    private static Map<String, List<SeoUrl>> seoUrlStoreMapByDomain = new HashMap();
    private static Map<String, List<Store>> storeMapByDomain = new HashMap();
    private static Map<String, List<Store>> storeMapById = new HashMap();
    private static Map<String, List<VoucherDeals>> offerMapByDomain = new HashMap();
    private static Map<String, List<VoucherDeals>> offerMapById = new HashMap();
    private static Map<String, List<VoucherDeals>> voucherMapByDomain = new HashMap();
    private static Map<String, List<VoucherDeals>> voucherMapById = new HashMap();
    private static Map<String, List<VoucherDeals>> dealMapByDomain = new HashMap();
    private static Map<String, List<VoucherDeals>> dealMapById = new HashMap();
    private static Map<String, List<Banner>> bannerMapByDomain = new HashMap();
    private static Map<String, List<BannerPage>> bannerPageMapByDomain = new HashMap();
    private static Map<String, List<Category>> categoryMapHome = new HashMap();
    private static Map<String, List<Category>> categoryMapPop = new HashMap();
    private static Map<String, List<VoucherDeals>> popOfferMapByDomain = new HashMap();
    private static Map<String, List<VoucherDeals>> popOfferMapById = new HashMap();
    private static Map<String, List<SubCategory>> subCategoryMapById = new HashMap();
    private static Map<String, List<Testimonial>> testimonialMapByDomainId = new HashMap();
    private static Map<String, List<VoucherDeals>> vdMapByStoreId = new HashMap();
    private static Map<String, List<Store>> allStoreMapByDomain = new HashMap();
    private static Map<String, List<Store>> allStoreMapById = new HashMap();
    private static Map<String, List<Category>> allCategoryMapPop = new HashMap();
    private static Map<String, List<VoucherDeals>> topOfferMapByDomain = new HashMap();
    private static Map<String, List<VoucherDeals>> topOfferMapById = new HashMap();
    private static Map<String, List<VoucherDeals>> top20VCMapByDomain = new HashMap();
    private static Map<String, List<VoucherDeals>> top20OfferMapByDomain = new HashMap();
    private static Map<String, List<VoucherDeals>> top20DealsMapByDomain = new HashMap();
    private static Map<String, Map<String, List<VoucherDeals>>> catOfferMapByDomain = new HashMap();
    private static Map<String, List<VoucherDeals>> endingSoonMap = new HashMap();
    private static Map<String, List<VoucherDeals>> exclusiveMap = new HashMap();
    private static Map<String, List<VoucherDeals>> expiredMap = new HashMap();
    private static Map<String, String> totalCouponsMap = new HashMap();
    private static Map<String, String> todaysCouponsMap = new HashMap();
    private static Map<String, String> totalStoresMap = new HashMap();
    private static Map<String, List<VoucherDeals>> expiredStoreMap = new HashMap();
    private static Map<String, String> contactMap = new HashMap();
    private static Map<String, List<AboutUs>> aboutusMap = new HashMap();
    private static Map<String, List<AllStores>> allStoreMapByName = new HashMap();
    private static Map<String, List<Hiring>> hiringMap = new HashMap();
    private static Map<String, List<ManagementTeam>> managementMap = new HashMap();
    private static Map<String, List<Privacy>> privacyMap = new HashMap();
    private static Map<String, String> FBAppIdMap = new HashMap();
    private static Map<String, String> MarqueeMap = new HashMap();
    private static Map<String, Map<String, List<VoucherDeals>>> storeCatOfferMap = new HashMap();
    private static Map<String, List<SearchKey>> searchKeysMap = new HashMap();
    private static Map<String, Map<String, List<VoucherDeals>>> storeBrandOfferMap = new HashMap();
    private static Map<String, Map<String, List<VoucherDeals>>> brandOfferMapByDomain = new HashMap();
    private static Map<String, List<Brand>> allBrandMapPop = new HashMap();
    private static Map<String, List<AllBrands>> allBrandsMapByName = new HashMap();
    private static Map<String, List<StoreCategory>> storeCatNameMap = new HashMap();
    private static Map<String, List<StoreCategory>> storeCatNameSCMap = new HashMap();
    private static Map<String, List<StoreBrand>> storeBrandNameMap = new HashMap();
    private static Map<String, String> CouponNotWorkedMap = new HashMap();
    private static Map<String, String> CancelOrderMap = new HashMap();
    private static Map<String, List<Faq>> faqListMap = new HashMap();
    private static Map<String, List<News>> newsListMap = new HashMap();
    private static Map<String, List<Articles>> articlesListMap = new HashMap();
    private static Map<String, List<Heading>> headListMap = new HashMap();
    private static Map<String, List<Specials>> allSpecialCatMap = new HashMap();
    private static Map<String, Map<String, List<VoucherDeals>>> specialOfferMapByDomain = new HashMap();
    private static Map<String, List<MetaTags>> metaMapByDomain = new HashMap();
    private static Map<String, Map<String, List<Specials>>> allSpecialCategories = new HashMap();
    private static Map<String, List<Specials>> allSpecialMap = new HashMap();
    private static Map<String, String> storeOfferCountMap = new HashMap();
    private static Map<String, String> storeOfferCountDeskMap = new HashMap();
    private static Map<String, List<VoucherDeals>> storeOfferMap = new HashMap();
    private static Map<String, List<Specials>> allSpecialOffersMap = new HashMap();
    private static Map<String, Integer> totalPopularStoresMap = new HashMap();
    private static Map<String, List<Domains>> domainsCountryListMap = new HashMap();
    private static Map<String, List<DomainGroup>> domainGroupListMap = new HashMap();
    private static Map<String, List<GlCountry>> domainCountryListMap = new HashMap();
    private static Map<String, List<VoucherDeals>> top20MobileOffersMapByDomain = new HashMap();
    private static Map<String, List<AllStoresMobile>> allStoreMapByNameMobile = new HashMap();
    private static Map<String, Map<String, List<VoucherDeals>>> catOfferMapByDomainMobile = new HashMap();
    private static Map<String, List<Domains>> domainsCountryMobileListMap = new HashMap();
    private static Map<String, List<Store>> topStoreMapByDomain = new HashMap();
    private static Map<String, Map<String, String>> productCatSeoMap = new HashMap();
    private static Map<String, Map<String, String>> productCatPathMap = new HashMap();
    private static Map<String, Map<String, String>> productBrandSeoMap = new HashMap();
    private static Map<String, List<ProductCategory>> topCat = new HashMap();
    private static Map<String, List<ProductBrand>> topBrand = new HashMap();
    private static Map<String, Map<String, List<Product>>> catProduct = new HashMap();
    private static Map<String, Map<String, FeedMeta>> feedMetaMap = new HashMap();
    private static Map<String, Map<String, List<FeedMeta>>> feedTagMap = new HashMap();
    private static Map<String, Map<String, List<MenuData>>> menuDataMap = new HashMap();
    private static Map<String, Map<String, List<ProductBrand>>> allBrand = new HashMap();
    private static Map<String, Map<String, List<ProductBrand>>> catBrand = new HashMap();
    private static Map<String, List<CategoryStores>> categoryTopStores = new HashMap();
    private static Map<String, String> solrUrlMap = new HashMap();
    private static Map<String, String> homeContentMap = new HashMap();
    private static Map<String, Map<String, Integer>> productCatPriority = new HashMap();
    private static Map<String, Map<String, Integer>> productCatBrandPriority = new HashMap();
    private static Map<String, Map<String, Integer>> productBrandPriority = new HashMap();
    private static Map<String, HttpSolrClient> solr = new HashMap();
    private static String statics;

    public static String getStatics() {
        return statics;
    }

    public static HttpSolrClient getSolr(String domainId) {
        return (HttpSolrClient)solr.get(domainId);
    }

    public static void setSolr(String domainId, HttpSolrClient aSolr) {
        solr.put(domainId, aSolr);
    }

    public List<ProductBrand> getTopBrand(String domainId) {
        return (List)topBrand.get(domainId);
    }

    private VcHome() {
    }

    public static void loadData() {
        loadData(Connect.newDb());
    }

    public static void loadDataFast() {
        BufferedReader br = null;
        ArrayList col = new ArrayList();

        try {
            Gson gson = new Gson();
            br = new BufferedReader(new FileReader(SystemConstant.CACHE_PATH + "cacheLoaded.json"));

            String sCurrentLine;
            while((sCurrentLine = br.readLine()) != null) {
                col.add(sCurrentLine);
            }

            Type type = (new VcHome$1()).getType();
            domainUrlMap = (Map)gson.fromJson((String)col.get(0), type);
            type = (new VcHome$2()).getType();
            domainGrpMap = (Map)gson.fromJson((String)col.get(1), type);
            type = (new VcHome$3()).getType();
            domainsListMap = (Map)gson.fromJson((String)col.get(2), type);
            type = (new VcHome$4()).getType();
            languageListMap = (Map)gson.fromJson((String)col.get(3), type);
            type = (new VcHome$5()).getType();
            labelsMap = (Map)gson.fromJson((String)col.get(4), type);
            type = (new VcHome$6()).getType();
            configMap = (Map)gson.fromJson((String)col.get(5), type);
            type = (new VcHome$7()).getType();
            seoUrlMapByDomain = (Map)gson.fromJson((String)col.get(6), type);
            type = (new VcHome$8()).getType();
            seoUrlStoreMapByDomain = (Map)gson.fromJson((String)col.get(7), type);
            type = (new VcHome$9()).getType();
            storeMapByDomain = (Map)gson.fromJson((String)col.get(8), type);
            type = (new VcHome$10()).getType();
            storeMapById = (Map)gson.fromJson((String)col.get(9), type);
            type = (new VcHome$11()).getType();
            offerMapByDomain = (Map)gson.fromJson((String)col.get(10), type);
            type = (new VcHome$12()).getType();
            offerMapById = (Map)gson.fromJson((String)col.get(11), type);
            type = (new VcHome$13()).getType();
            voucherMapByDomain = (Map)gson.fromJson((String)col.get(12), type);
            type = (new VcHome$14()).getType();
            voucherMapById = (Map)gson.fromJson((String)col.get(13), type);
            type = (new VcHome$15()).getType();
            dealMapByDomain = (Map)gson.fromJson((String)col.get(14), type);
            type = (new VcHome$16()).getType();
            dealMapById = (Map)gson.fromJson((String)col.get(15), type);
            type = (new VcHome$17()).getType();
            bannerMapByDomain = (Map)gson.fromJson((String)col.get(16), type);
            type = (new VcHome$18()).getType();
            bannerPageMapByDomain = (Map)gson.fromJson((String)col.get(17), type);
            type = (new VcHome$19()).getType();
            categoryMapHome = (Map)gson.fromJson((String)col.get(18), type);
            type = (new VcHome$20()).getType();
            categoryMapPop = (Map)gson.fromJson((String)col.get(19), type);
            type = (new VcHome$21()).getType();
            popOfferMapByDomain = (Map)gson.fromJson((String)col.get(20), type);
            type = (new VcHome$22()).getType();
            popOfferMapById = (Map)gson.fromJson((String)col.get(21), type);
            type = (new VcHome$23()).getType();
            subCategoryMapById = (Map)gson.fromJson((String)col.get(22), type);
            type = (new VcHome$24()).getType();
            testimonialMapByDomainId = (Map)gson.fromJson((String)col.get(23), type);
            type = (new VcHome$25()).getType();
            vdMapByStoreId = (Map)gson.fromJson((String)col.get(24), type);
            type = (new VcHome$26()).getType();
            allStoreMapByDomain = (Map)gson.fromJson((String)col.get(25), type);
            type = (new VcHome$27()).getType();
            allStoreMapById = (Map)gson.fromJson((String)col.get(26), type);
            type = (new VcHome$28()).getType();
            allCategoryMapPop = (Map)gson.fromJson((String)col.get(27), type);
            type = (new VcHome$29()).getType();
            topOfferMapByDomain = (Map)gson.fromJson((String)col.get(28), type);
            type = (new VcHome$30()).getType();
            topOfferMapById = (Map)gson.fromJson((String)col.get(29), type);
            type = (new VcHome$31()).getType();
            top20VCMapByDomain = (Map)gson.fromJson((String)col.get(30), type);
            type = (new VcHome$32()).getType();
            top20OfferMapByDomain = (Map)gson.fromJson((String)col.get(31), type);
            type = (new VcHome$33()).getType();
            top20DealsMapByDomain = (Map)gson.fromJson((String)col.get(32), type);
            type = (new VcHome$34()).getType();
            catOfferMapByDomain = (Map)gson.fromJson((String)col.get(33), type);
            type = (new VcHome$35()).getType();
            endingSoonMap = (Map)gson.fromJson((String)col.get(34), type);
            type = (new VcHome$36()).getType();
            expiredMap = (Map)gson.fromJson((String)col.get(35), type);
            type = (new VcHome$37()).getType();
            totalCouponsMap = (Map)gson.fromJson((String)col.get(36), type);
            type = (new VcHome$38()).getType();
            todaysCouponsMap = (Map)gson.fromJson((String)col.get(37), type);
            type = (new VcHome$39()).getType();
            totalStoresMap = (Map)gson.fromJson((String)col.get(38), type);
            type = (new VcHome$40()).getType();
            expiredStoreMap = (Map)gson.fromJson((String)col.get(39), type);
            type = (new VcHome$41()).getType();
            contactMap = (Map)gson.fromJson((String)col.get(40), type);
            type = (new VcHome$42()).getType();
            aboutusMap = (Map)gson.fromJson((String)col.get(41), type);
            type = (new VcHome$43()).getType();
            allStoreMapByName = (Map)gson.fromJson((String)col.get(42), type);
            type = (new VcHome$44()).getType();
            hiringMap = (Map)gson.fromJson((String)col.get(43), type);
            type = (new VcHome$45()).getType();
            managementMap = (Map)gson.fromJson((String)col.get(44), type);
            type = (new VcHome$46()).getType();
            privacyMap = (Map)gson.fromJson((String)col.get(45), type);
            type = (new VcHome$47()).getType();
            FBAppIdMap = (Map)gson.fromJson((String)col.get(46), type);
            type = (new VcHome$48()).getType();
            storeCatOfferMap = (Map)gson.fromJson((String)col.get(47), type);
            type = (new VcHome$49()).getType();
            searchKeysMap = (Map)gson.fromJson((String)col.get(48), type);
            type = (new VcHome$50()).getType();
            storeBrandOfferMap = (Map)gson.fromJson((String)col.get(49), type);
            type = (new VcHome$51()).getType();
            brandOfferMapByDomain = (Map)gson.fromJson((String)col.get(50), type);
            type = (new VcHome$52()).getType();
            allBrandMapPop = (Map)gson.fromJson((String)col.get(51), type);
        } catch (IOException var13) {
             var13 = var13;
            var13.printStackTrace();
        } finally {
            try {
                if (br != null) {
                    br.close();
                }
            } catch (IOException var12) {
                IOException newvar12 = var12;
                newvar12.printStackTrace();
            }

        }

    }

    private static void getType() {
    }

    public static void loadData(Db db) {
        try {
            long startTime = System.currentTimeMillis();
            VcHomeLoader.generateCurrentDateForDomain(db);
            statics = "<table><tr><td>generateCurrentDateForDomain(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadKeyPair(db, domainUrlMap, "SELECT  domain_url, id FROM vc_domain");
            statics = statics + "<tr><td>loadKeyPair-domainUrlMap(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadSolrUrl(db, solrUrlMap);
            statics = statics + "<tr><td>loadSolrUrl (mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadKeyPair(db, domainGrpMap, "SELECT  id,domain_group_id FROM vc_domain");
            statics = statics + "<tr><td>loadKeyPair-domainGrpMap(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadDomains(db, domainsListMap);
            statics = statics + "<tr><td>loadDomains(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadLanguages(db, languageListMap);
            statics = statics + "<tr><td>loadLanguages(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadLabels(db, labelsMap);
            statics = statics + "<tr><td>loadLabels(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadConfig(db, configMap);
            statics = statics + "<tr><td>loadConfig(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadSeoUrl(db, seoUrlMapByDomain);
            statics = statics + "<tr><td>loadSeoUrl(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadSeoUrlStore(db, seoUrlStoreMapByDomain);
            statics = statics + "<tr><td>loadSeoUrlStore(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadStoreCategoryOffers(db, storeCatOfferMap);
            statics = statics + "<tr><td>loadStoreCategoryOffers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadStore(db, storeMapByDomain, storeMapById);
            statics = statics + "<tr><td>loadStore(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTopOffers(db, offerMapByDomain, offerMapById);
            statics = statics + "<tr><td>loadTopOffers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadLatestVouchers(db, voucherMapByDomain, voucherMapById);
            statics = statics + "<tr><td>loadLatestVouchers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadLatestDeals(db, dealMapByDomain, dealMapById);
            statics = statics + "<tr><td>loadLatestDeals(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadBanner(db, bannerMapByDomain);
            statics = statics + "<tr><td>loadBanner(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadBannerPage(db, bannerPageMapByDomain);
            statics = statics + "<tr><td>loadBannerPage(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadHomeCategories(db, categoryMapHome);
            statics = statics + "<tr><td>loadHomeCategories(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadPopularCategories(db, categoryMapPop);
            statics = statics + "<tr><td>loadPopularCategories(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadPopularOffers(db, popOfferMapByDomain, popOfferMapById);
            statics = statics + "<tr><td>loadPopularOffers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadSubCategory(db, subCategoryMapById);
            statics = statics + "<tr><td>loadSubCategory(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTestimonial(db, testimonialMapByDomainId);
            statics = statics + "<tr><td>loadTestimonial(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadAllVD(db, vdMapByStoreId);
            statics = statics + "<tr><td>loadAllVD(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadAllStores(db, allStoreMapByDomain, allStoreMapById);
            statics = statics + "<tr><td>loadAllStores(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadCategories(db, allCategoryMapPop);
            statics = statics + "<tr><td>loadCategories(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTopDeals(db, topOfferMapByDomain, topOfferMapById);
            statics = statics + "<tr><td>loadTopDeals(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTop20Vouchers(db, top20VCMapByDomain);
            statics = statics + "<tr><td>loadTop20Vouchers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTop20Deals(db, top20DealsMapByDomain);
            statics = statics + "<tr><td>loadTop20Deals(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTop20Offers(db, top20OfferMapByDomain);
            statics = statics + "<tr><td>loadTop20Offers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTop20OffersMobile(db, top20MobileOffersMapByDomain);
            statics = statics + "<tr><td>loadTop20OffersMobile(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadCategoryOffers(db, catOfferMapByDomain);
            statics = statics + "<tr><td>loadCategoryOffers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadEndingSoon(db, endingSoonMap);
            statics = statics + "<tr><td>loadEndingSoon(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadExclusive(db, exclusiveMap);
            statics = statics + "<tr><td>loadExclusive(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadExpiredVouchers(db, expiredMap);
            statics = statics + "<tr><td>loadExpiredVouchers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTotalCoupons(db, totalCouponsMap);
            statics = statics + "<tr><td>loadTotalCoupons(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTodaysTotalCoupons(db, todaysCouponsMap);
            statics = statics + "<tr><td>loadTodaysTotalCoupons(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTotalStores(db, totalStoresMap);
            statics = statics + "<tr><td>loadTotalStores(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadExpiredVouchersStore(db, expiredStoreMap);
            statics = statics + "<tr><td>loadExpiredVouchersStore(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadContactAddress(db, contactMap);
            statics = statics + "<tr><td>loadContactAddress(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadAboutUs(db, aboutusMap);
            statics = statics + "<tr><td>loadAboutUs(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadAllStoresByName(db, allStoreMapByName);
            statics = statics + "<tr><td>loadAllStoresByName(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadWeAreHiring(db, hiringMap);
            statics = statics + "<tr><td>loadWeAreHiring(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadManagementTeam(db, managementMap);
            statics = statics + "<tr><td>loadManagementTeam(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadPrivacy(db, privacyMap);
            statics = statics + "<tr><td>loadPrivacy(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadAppId(db, FBAppIdMap);
            statics = statics + "<tr><td>loadAppId(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadMarquee(db, MarqueeMap);
            statics = statics + "<tr><td>loadMarquee(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadSearchKey(db, searchKeysMap);
            statics = statics + "<tr><td>loadSearchKey(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadStoreBrandOffers(db, storeBrandOfferMap);
            statics = statics + "<tr><td>loadStoreBrandOffers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadBrandOffers(db, brandOfferMapByDomain);
            statics = statics + "<tr><td>loadBrandOffers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadBrands(db, allBrandMapPop);
            statics = statics + "<tr><td>loadBrands(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadAllBrandsByName(db, allBrandsMapByName);
            statics = statics + "<tr><td>loadAllBrandsByName(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            VcHomeLoader.loadAllBrandsByCategory(db, catBrand);
            statics = statics + "<tr><td>loadAllBrandsByCategory(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadStoreCatName(db, storeCatNameMap);
            statics = statics + "<tr><td>loadStoreCatName(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadStoreCatNameForSimilarCoupon(db, storeCatNameSCMap);
            statics = statics + "<tr><td>loadStoreCatName(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadStoreBrandName(db, storeBrandNameMap);
            statics = statics + "<tr><td>loadStoreBrandName(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadCouponNotWorked(db, CouponNotWorkedMap);
            statics = statics + "<tr><td>loadCouponNotWorked(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadCancelOrders(db, CancelOrderMap);
            statics = statics + "<tr><td>loadCancelOrders(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadFaq(db, faqListMap);
            statics = statics + "<tr><td>loadFaq(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadNews(db, newsListMap);
            statics = statics + "<tr><td>loadNews(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadArticles(db, articlesListMap);
            statics = statics + "<tr><td>loadArticles(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadHead(db, headListMap);
            statics = statics + "<tr><td>loadHead(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadAllSpecialsCat(db, allSpecialCatMap);
            statics = statics + "<tr><td>loadAllSpecialsCat(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadSpecialOffers(db, specialOfferMapByDomain);
            statics = statics + "<tr><td>loadSpecialOffers(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadMetaData(db, metaMapByDomain);
            statics = statics + "<tr><td>loadMetaData(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadCatSpecials(db, allSpecialCategories);
            statics = statics + "<tr><td>loadCatSpecials(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadOfferCountStore(db, storeOfferCountMap);
            statics = statics + "<tr><td>loadOfferCountStore(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadOfferCountStoreDesktop(db, storeOfferCountDeskMap);
            statics = statics + "<tr><td>loadOfferCountStore(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadAllSpecials(db, allSpecialMap);
            statics = statics + "<tr><td>loadAllSpecials(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadSpecials(db, allSpecialOffersMap);
            statics = statics + "<tr><td>loadSpecials(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTotalPopularStores(db, totalPopularStoresMap);
            statics = statics + "<tr><td>loadTotalPopularStores(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadDomainsCountry(db, domainsCountryListMap);
            statics = statics + "<tr><td>loadDomainsCountry(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadDomainGroup(db, domainGroupListMap);
            statics = statics + "<tr><td>loadDomainGroup(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadDomainCountry(db, domainCountryListMap);
            statics = statics + "<tr><td>loadDomainCountry(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadAllStoresByNameMobile(db, allStoreMapByNameMobile);
            statics = statics + "<tr><td>loadAllStoresByNameMobile(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadCategoryOffersMobile(db, catOfferMapByDomainMobile);
            statics = statics + "<tr><td>loadCategoryOffersMobile(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadDomainsCountryMobile(db, domainsCountryMobileListMap);
            statics = statics + "<tr><td>loadDomainsCountryMobile(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            startTime = System.currentTimeMillis();
            VcHomeLoader.loadTopStoreMobile(db, topStoreMapByDomain);
            statics = statics + "<tr><td>loadTopStoreMobile(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            VcHomeLoader.loadCategoryTopStores(db, categoryTopStores);
            statics = statics + "<tr><td>loadCategoryTopStores(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            VcHomeLoader.loadHomeContent(db, homeContentMap);
            statics = statics + "<tr><td>loadHomeContent(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
            if ("yes".equalsIgnoreCase(SystemConstant.ENABLE_FEED_ON_SERVER)) {
                try {
                    VcHomeLoader.loadTopCatSeo(db, topCat);
                    statics = statics + "<tr><td>loadTopCatSeo(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    productCatPathMap = VcHomeLoader.loadProductCatPath(db, productCatPathMap);
                    statics = statics + "<tr><td>loadProductCatPath(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    productCatSeoMap = VcHomeLoader.loadProductCatSeo(db, productCatSeoMap);
                    statics = statics + "<tr><td>productCatSeoMap(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    VcHomeLoader.loadTopBrandSeo(db, topBrand);
                    statics = statics + "<tr><td>loadTopBrandSeo(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    productBrandSeoMap = VcHomeLoader.loadProductBrandSeo(db, productBrandSeoMap);
                    statics = statics + "<tr><td>loadBrandCatSeo(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    feedMetaMap = VcHomeLoader.loadFeedMeta(db, feedMetaMap);
                    statics = statics + "<tr><td>feedMetaMap(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    startTime = System.currentTimeMillis();
                    VcHomeLoader.loadFeedTagMap(db, feedTagMap);
                    statics = statics + "<tr><td>feedTagMap(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    VcHomeLoader.loadCatProduct(db, catProduct, topCat);
                    statics = statics + "<tr><td>catProduct(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    startTime = System.currentTimeMillis();
                    VcHomeLoader.loadAllBrand(db, allBrand);
                    statics = statics + "<tr><td>loadAllBrand(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr></table>";
                    menuDataMap = VcHomeLoader.loadCategoryData(db, menuDataMap);
                    statics = statics + "<tr><td>loadCategoryData(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    productCatBrandPriority = VcHomeLoader.loadProductCatBrandPriority(db, productCatBrandPriority);
                    statics = statics + "<tr><td>loadProductCatBrandPriority(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    productCatPriority = VcHomeLoader.loadProductCatPriority(db, productCatPriority);
                    statics = statics + "<tr><td>loadProductCatPriority(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                    productBrandPriority = VcHomeLoader.loadProductBrandPriority(db, productBrandPriority);
                    statics = statics + "<tr><td>loadProductBrandPriority(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr>";
                } catch (Exception var8) {
                }
            }

            startTime = System.currentTimeMillis();
            VcHomeLoader.removeCurrentDateForDomainTable(db);
            statics = statics + "<tr><td>removeCurrentDateForDomainTable(mili sec):</td><td>" + (System.currentTimeMillis() - startTime) + "</td></tr></table>";
        } catch (SQLException | IOException var9) {

            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var9);
        } finally {
            if (db != null) {
                db.close();
            }

        }

    }

    public static VcHome instance() {
        return vcHome;
    }

    public String getDomainId(String domainUrl) {
        return (String)domainUrlMap.get(domainUrl);
    }

    public String getDomainScheme(String domainUrl) {
        String scheme = null;
        if (domainsListMap.get(domainGrpMap.get(domainUrlMap.get(domainUrl))) != null) {
            scheme = this.getDomain((List)domainsListMap.get(domainGrpMap.get(domainUrlMap.get(domainUrl))), (String)domainUrlMap.get(domainUrl)).getScheme();
        }

        return scheme == null ? "https" : scheme;
    }

    public String getsolrUrl(String domainId) {
        return solrUrlMap.get(domainId) != null ? (String)solrUrlMap.get(domainId) : (String)solrUrlMap.get("36");
    }

    public String getDomainTheme(String domainId) {
        String theme = null;
        List<Domains> domains = this.getDomains(domainId);
        Domains domain = null;
        if (domains != null) {
            domain = this.getDomain(domains, domainId);
        }

        if (domain != null) {
            theme = domain.getThemeId();
        }

        return theme;
    }

    public void setThemeType(String domainId, String theme) {
        List<Domains> domains = this.getDomains(domainId);
        Domains domain = null;
        if (domains != null) {
            domain = this.getDomain(domains, domainId);
        }

        if (domain != null) {
            domain.setThemeType(theme);
        }

    }

    public List<Domains> getDomains(String domainId) {
        return (List)domainsListMap.get(domainGrpMap.get(domainId));
    }

    public List<Faq> getFaq(String domainId) {
        return (List)faqListMap.get(domainId);
    }

    public List<News> getNews(String storeId) {
        return (List)newsListMap.get(storeId);
    }

    public List<Articles> getArticles(String storeId) {
        return (List)articlesListMap.get(storeId);
    }

    public List<Heading> getHeading(String domainId) {
        return (List)headListMap.get(domainId);
    }

    public Domains getDomain(List<Domains> domains, String domainId) {
        Iterator var3 = domains.iterator();

        while(var3.hasNext()) {
            Domains domains1 = (Domains)var3.next();
            if (domains1.getId().equals(domainId)) {
                return domains1;
            }
        }

        return null;
    }

    public Domains getDomain(String domainId) {
        Iterator var2 = this.getDomains(domainId).iterator();

        while(var2.hasNext()) {
            Domains domains1 = (Domains)var2.next();
            if (domains1.getId().equals(domainId)) {
                return domains1;
            }
        }

        return null;
    }

    public List<Language> getLanguages(String domainId) {
        return (List)languageListMap.get(domainId);
    }

    public Properties getLabels(String languageId) {
        return (Properties)labelsMap.get(languageId);
    }

    public HomeConfig getConfig(String domainId) {
        return (HomeConfig)configMap.get(domainId);
    }

    public List<SeoUrl> getSeoByDomainId(String domainId) {
        return (List)seoUrlMapByDomain.get(domainId);
    }

    public List<SeoUrl> getSeoStoreByDomainId(String domainId) {
        return (List)seoUrlStoreMapByDomain.get(domainId);
    }

    public List<Store> getStoreByDomainId(String domainId) {
        return (List)storeMapByDomain.get(domainId);
    }

    public List<Store> getStoreById(String storeId) {
        return (List)storeMapById.get(storeId);
    }

    public List<VoucherDeals> getOfferByDomainId(String domainId) {
        return (List)offerMapByDomain.get(domainId);
    }

    public List<VoucherDeals> getOfferById(String storeId) {
        return (List)offerMapById.get(storeId);
    }

    public List<VoucherDeals> getVoucherByDomainId(String domainId) {
        return (List)voucherMapByDomain.get(domainId);
    }

    public List<VoucherDeals> getVoucherById(String storeId) {
        return (List)voucherMapById.get(storeId);
    }

    public List<VoucherDeals> getDealByDomainId(String domainId) {
        return (List)dealMapByDomain.get(domainId);
    }

    public List<VoucherDeals> getDealById(String storeId) {
        return (List)dealMapById.get(storeId);
    }

    public List<Banner> getBannerByDomainId(String domainId) {
        return (List)bannerMapByDomain.get(domainId);
    }

    public List<BannerPage> getBannerPageByDomainId(String domainId) {
        return (List)bannerPageMapByDomain.get(domainId);
    }

    public List<Category> getHomeCatByDomainId(String domainId) {
        return (List)categoryMapHome.get(domainId);
    }

    public List<Category> getPopCatByDomainId(String domainId) {
        return (List)categoryMapPop.get(domainId);
    }

    public List<VoucherDeals> getPopOfferByDomainId(String domainId) {
        return (List)popOfferMapByDomain.get(domainId);
    }

    public List<VoucherDeals> getPopOfferId(String offerId) {
        return (List)popOfferMapById.get(offerId);
    }

    public List<SubCategory> getSubCategoryById(String categoryId) {
        return (List)subCategoryMapById.get(categoryId);
    }

    public List<Testimonial> getTestimonialByDomainId(String domainId) {
        return (List)testimonialMapByDomainId.get(domainId);
    }

    public List<VoucherDeals> getAllVDById(String storeId) {
        return (List)vdMapByStoreId.get(storeId);
    }

    public Map<String, List<VoucherDeals>> getAllVD() {
        return vdMapByStoreId;
    }

    public List<Store> getAllStoreById(String storeId) {
        return (List)allStoreMapById.get(storeId);
    }

    public List<Store> getAllStoresByDomainId(String domainId) {
        return (List)allStoreMapByDomain.get(domainId);
    }

    public List<Category> getCatByDomainId(String domainId) {
        return (List)allCategoryMapPop.get(domainId);
    }

    public List<Specials> getCategorySpecial(String domainId, String categoryId) {
        return allSpecialCategories.get(domainId) != null ? (List)((Map)allSpecialCategories.get(domainId)).get(categoryId) : null;
    }

    public List<Specials> getAllSpecial(String domainId) {
        return allSpecialMap.get(domainId) != null ? (List)allSpecialMap.get(domainId) : null;
    }

    public List<String> getSimilarStores(String storeId, String domainId) {
        Db db = null;
        List<String> storeList = new ArrayList();
        if (storeId != null && !"".equals(storeId)) {
            try {
                db = Connect.newDb();
                storeList = VcHomeLoader.loadSimilarStores(db, storeId, domainId);
            } catch (SQLException var9) {
                 var9 = var9;
                Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var9);
            } finally {
                if (db != null) {
                    db.close();
                }

            }

            return (List)storeList;
        } else {
            return null;
        }
    }

    public List<CategoryStores> getTopStores(String domainId) {
        return (List)categoryTopStores.get(domainId);
    }

    public List<String> getSimilarStoresTopPages(String storeId, String domainId) {
        Db db = null;
        Object storeList = new ArrayList();

        try {
            db = Connect.newDb();
            storeList = VcHomeLoader.loadSimilarStoresTopPages(db, storeId, domainId);
        } catch (SQLException var9) {
             var9 = var9;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var9);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return (List)storeList;
    }

    public List<VoucherDeals> getTopDealByDomainId(String domainId) {
        return (List)topOfferMapByDomain.get(domainId);
    }

    public List<VoucherDeals> getTop20VCByDomainId(String domainId) {
        return (List)top20VCMapByDomain.get(domainId);
    }

    public List<VoucherDeals> getTop20DealByDomainId(String domainId) {
        return (List)top20DealsMapByDomain.get(domainId);
    }

    public List<VoucherDeals> getTop20OffersByDomainId(String domainId) {
        return (List)top20OfferMapByDomain.get(domainId);
    }

    public List<VoucherDeals> getCatOfferByDomainId(String domainId, String catId) {
        return catOfferMapByDomain.get(domainId) != null ? (List)((Map)catOfferMapByDomain.get(domainId)).get(catId) : null;
    }

    public List<VoucherDeals> getEndingSoonByDomainId(String domainId) {
        return (List)endingSoonMap.get(domainId);
    }

    public List<VoucherDeals> getExclusiveByDomainId(String domainId) {
        return (List)exclusiveMap.get(domainId);
    }

    public List<VoucherDeals> getExpiredByDomainId(String domainId) {
        return (List)expiredMap.get(domainId);
    }

    public String getTotalCoupons(String domainId) {
        return (String)totalCouponsMap.get(domainId);
    }

    public Integer getTotalPupularStores(String domainId) {
        return (Integer)totalPopularStoresMap.get(domainId);
    }

    public String getTodaysCoupons(String domainId) {
        return (String)todaysCouponsMap.get(domainId);
    }

    public String getTotalStores(String domainId) {
        return (String)totalStoresMap.get(domainId);
    }

    public List<VoucherDeals> getExpiredVouchersStore(String storeId) {
        return (List)expiredStoreMap.get(storeId);
    }

    public String getContactAddress(String domainId) {
        return (String)contactMap.get(domainId);
    }

    public List<AboutUs> getAboutUs(String domainId) {
        return (List)aboutusMap.get(domainId);
    }

    public List<AllStores> getAllStoreByName(String domainId) throws SQLException {
        return (List)allStoreMapByName.get(domainId);
    }

    public List<Hiring> getHiring() {
        return (List)hiringMap.get("1");
    }

    public List<ManagementTeam> getManagementTeam(String domainId) {
        return (List)managementMap.get(domainId);
    }

    public List<Privacy> getPrivacy(String domainId) {
        return (List)privacyMap.get(domainId);
    }

    public String getAppId(String domainId) {
        return (String)FBAppIdMap.get(domainId);
    }

    public String getMarquee(String domainId) {
        return (String)MarqueeMap.get(domainId);
    }

    public List<VoucherDeals> getSeachResult(String key, String domainId, String languageId) {
        Db db = null;
        Object searchList = new ArrayList();

        try {
            db = Connect.newDb();
            searchList = VcHomeLoader.loadSearchResult(db, key, domainId, languageId);
        } catch (SQLException var10) {
             var10 = var10;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var10);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return (List)searchList;
    }

    public List<VoucherDeals> getStoreCatOfferByStoreId(String storeId, String catId) {
        return storeCatOfferMap.get(storeId) != null ? (List)((Map)storeCatOfferMap.get(storeId)).get(catId) : null;
    }

    public List<VoucherDeals> getStorBrandOfferByStoreId(String storeId, String brandId) {
        return storeBrandOfferMap.get(storeId) != null ? (List)((Map)storeBrandOfferMap.get(storeId)).get(brandId) : null;
    }

    public List<SearchKey> getSearchKey() {
        return (List)searchKeysMap.get("1");
    }

    public List<VoucherDeals> getBrandOfferByDomainId(String domainId, String brandId) {
        return brandOfferMapByDomain.get(domainId) != null ? (List)((Map)brandOfferMapByDomain.get(domainId)).get(brandId) : null;
    }

    public List<Brand> getBrandByDomainId(String domainId) {
        return (List)allBrandMapPop.get(domainId);
    }

    public List<AllBrands> getAllBrandsByName(String domainId) throws SQLException {
        return (List)allBrandsMapByName.get(domainId);
    }

    public Map<String, List<ProductBrand>> getBrandsByCategory(String domainId) throws SQLException {
        return (Map)catBrand.get(domainId);
    }

    public List<StoreCategory> getStoreCatName(String storeId) throws SQLException {
        return (List)storeCatNameMap.get(storeId);
    }

    public List<StoreCategory> getStoreCatNameSC(String storeId) throws SQLException {
        return (List)storeCatNameSCMap.get(storeId);
    }

    public List<StoreBrand> getStoreBrandName(String storeId) throws SQLException {
        return (List)storeBrandNameMap.get(storeId);
    }

    public String getCouponNotWorked(String domainId) {
        return (String)CouponNotWorkedMap.get(domainId);
    }

    public String getCancelOrder(String domainId) {
        return (String)CancelOrderMap.get(domainId);
    }

    public List<VoucherDeals> getCouponDetails(Db db, String offerId, String languageId, String domainId) {
        Object couponDetailsList = new ArrayList();

        try {
            SQLException var6;
            try {
                if (offerId == null) {
                    var6 = null;
                    List var7 = (List)var6;
                    return var7;
                }

                couponDetailsList = VcHomeLoader.loadCouponDetails(db, offerId, languageId, domainId);
            } catch (SQLException var11) {
                var6 = var11;
                Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var6);
            }

            List var13 = (List)couponDetailsList;
            return var13;
        } finally {
            ;
        }
    }

    public String getSeoUrlActive(String pageType, String pageTypeFk, String languageId, String domainId) {
        Db db = null;
        String activeUrl = null;

        try {
            db = Connect.newDb();
            activeUrl = VcHomeLoader.loadSeoUrlActive(db, pageType, pageTypeFk, languageId, domainId);
        } catch (SQLException var11) {
             var11 = var11;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var11);
        } finally {
            db.select().clean();
            db.close();
        }

        return activeUrl;
    }

    public String getCampaignFile(String campId) {
        Db db = null;
        String zipFile = null;

        try {
            db = Connect.newDb();
            zipFile = VcHomeLoader.loadZipFileCampaign(db, campId);
        } catch (SQLException var8) {
             var8 = var8;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var8);
        } finally {
            db.select().clean();
            db.close();
        }

        return zipFile;
    }

    public String getCatUrl(String catId, String domainId, String languageId) {
        Db db = null;
        String catSeoUrl = null;

        try {
            db = Connect.newDb();
            catSeoUrl = VcHomeLoader.loadcategoryUrl(db, catId, domainId, languageId);
        } catch (SQLException var10) {
             var10 = var10;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var10);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return catSeoUrl;
    }

    public String getCatId(String name, String languageId) {
        Db db = null;
        String catId = null;

        try {
            db = Connect.newDb();
            catId = VcHomeLoader.loadcategoryId(db, name, languageId);
        } catch (SQLException var9) {
             var9 = var9;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var9);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return catId;
    }

    public List<Specials> getSpecialCatDomainId(String domainId) {
        return (List)allSpecialCatMap.get(domainId);
    }

    public List<VoucherDeals> getSpecialOfferByDomainId(String domainId, String specialId) {
        return specialOfferMapByDomain.get(domainId) != null ? (List)((Map)specialOfferMapByDomain.get(domainId)).get(specialId) : null;
    }

    public String getCatName(String domainId, String seo, String languageId) {
        Db db = null;
        String catName = null;

        try {
            db = Connect.newDb();
            catName = VcHomeLoader.loadCategoryName(db, domainId, seo, languageId);
        } catch (SQLException var10) {
             var10 = var10;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var10);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return catName;
    }

    public String getStoreName(String domainId, String seo) {
        Db db = null;
        String storeName = null;

        try {
            db = Connect.newDb();
            storeName = VcHomeLoader.loadStoreName(db, domainId, seo);
        } catch (SQLException var9) {
             var9 = var9;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var9);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return storeName;
    }

    public String getSpecialName(String domainId, String seo) {
        Db db = null;
        String specialName = null;

        try {
            db = Connect.newDb();
            specialName = VcHomeLoader.loadSpecialName(db, domainId, seo);
        } catch (SQLException var9) {
             var9 = var9;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var9);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return specialName;
    }

    public String getStoreCatNameTopMenu(String domainId, String seo, String languageId) {
        Db db = null;
        String storeCatName = null;

        try {
            db = Connect.newDb();
            storeCatName = VcHomeLoader.loadStoreCatNameTopMenu(db, domainId, seo, languageId);
        } catch (SQLException var10) {
             var10 = var10;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var10);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return storeCatName;
    }

    public String getStoreBrandName(String domainId, String seo, String languageId) {
        Db db = null;
        String storeBrandName = null;

        try {
            db = Connect.newDb();
            storeBrandName = VcHomeLoader.loadStoreBrandName(db, domainId, seo, languageId);
        } catch (SQLException var10) {
             var10 = var10;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var10);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return storeBrandName;
    }

    public String getStoreCoupon(String domainId, String couponId) {
        Db db = null;
        String storeCouponName = null;

        try {
            db = Connect.newDb();
            storeCouponName = VcHomeLoader.loadStoreCouponName(db, domainId, couponId);
        } catch (SQLException var9) {
             var9 = var9;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var9);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return storeCouponName;
    }

    public List<MetaTags> getMetaByDomainId(String domainId) {
        return (List)metaMapByDomain.get(domainId);
    }

    public void logUser(String userInfo) {
        Db db = null;

        try {
            db = Connect.newDb();
            VcHomeLoader.logUser(db, userInfo);
        } catch (SQLException var7) {
             var7 = var7;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var7);
        } finally {
            if (db != null) {
                db.close();
            }

        }

    }

    public String getSpecialCat(String catId) {
        Db db = null;
        String catName = null;

        try {
            db = Connect.newDb();
            catName = VcHomeLoader.loadSpecialCatName(db, catId);
        } catch (SQLException var8) {
             var8 = var8;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var8);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return catName;
    }

    public String getSpecialDet(String specialId) {
        Db db = null;
        String speDet = null;

        try {
            db = Connect.newDb();
            speDet = VcHomeLoader.loadSpecialDet(db, specialId);
        } catch (SQLException var8) {
             var8 = var8;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var8);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return speDet;
    }

    public List<Specials> getSimilarCatSpecials(String domainId, String langId, String spId) {
        Db db = null;
        List specialListDomain = null;

        try {
            db = Connect.newDb();
            specialListDomain = VcHomeLoader.loadSimilarCatSpecials(db, domainId, langId, spId);
        } catch (SQLException var10) {
             var10 = var10;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var10);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return specialListDomain;
    }

    public String getStoreOfferCount(String storeId) {
        return (String)storeOfferCountMap.get(storeId);
    }

    public String getStoreOfferCountDesk(String storeId) {
        return (String)storeOfferCountDeskMap.get(storeId);
    }

    public List<VoucherDeals> getSimilarStoresOffers(String storeId, String languageId, String catId) {
        Db db = null;
        Object offerList = new ArrayList();

        try {
            db = Connect.newDb();
            offerList = VcHomeLoader.loadSimilarStoreOffer(db, storeId, languageId, catId);
        } catch (SQLException var10) {
             var10 = var10;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var10);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return (List)offerList;
    }

    public List<Specials> getSpecialsDomainId(String domainId) {
        return (List)allSpecialOffersMap.get(domainId);
    }

    public List<Domains> getDomainsCountry() {
        return (List)domainsCountryListMap.get("1");
    }

    public List<DomainGroup> getDomainGroup() {
        return (List)domainGroupListMap.get("1");
    }

    public List<GlCountry> getDomainCountry(String domainGroupId) {
        return (List)domainCountryListMap.get(domainGroupId);
    }

    public List<GlCountry> getDomainCountryAll() {
        List<GlCountry> list = new ArrayList();
        Iterator var2 = domainCountryListMap.values().iterator();

        while(var2.hasNext()) {
            List<GlCountry> ent = (List)var2.next();
            list.addAll(ent);
        }

        return list;
    }

    public List<VoucherDeals> getTop20MobileOffers(String domainId) {
        return (List)top20MobileOffersMapByDomain.get(domainId);
    }

    public List<AllStoresMobile> getAllStoreByNameMobile(String domainId) throws SQLException {
        return (List)allStoreMapByNameMobile.get(domainId);
    }

    public List<VoucherDeals> getCatOfferByDomainIdMobile(String domainId, String catId) {
        return catOfferMapByDomainMobile.get(domainId) != null ? (List)((Map)catOfferMapByDomainMobile.get(domainId)).get(catId) : null;
    }

    public List<Domains> getDomainsCountryMobile() {
        return (List)domainsCountryMobileListMap.get("1");
    }

    public List<Store> getTopStoreByDomainId(String domainId) {
        return (List)topStoreMapByDomain.get(domainId);
    }

    public List<Store> getStoreByName(String domainId, String languageId, String name) {
        Db db = null;
        Object storeList = new ArrayList();

        try {
            db = Connect.newDb();
            storeList = VcHomeLoader.loadStoreMobileByName(db, domainId, languageId, name);
        } catch (SQLException var10) {
             var10 = var10;
            Logger.getLogger(VcHome.class.getName()).log(Level.SEVERE, (String)null, var10);
        } finally {
            if (db != null) {
                db.close();
            }

        }

        return (List)storeList;
    }

    public String getProductCatSeo(String domainId, String seo) {
        return productCatSeoMap.get(domainId) != null ? (String)((Map)productCatSeoMap.get(domainId)).get(seo) : null;
    }

    public Integer getProductCatPriority(String domainId, String seo) {
        return productCatPriority.get(domainId) != null ? null != ((Map)productCatPriority.get(domainId)).get(seo) ? (Integer)((Map)productCatPriority.get(domainId)).get(seo) : 1000 : 1000;
    }

    public Integer getProductCatBraPriority(String domainId, String seo) {
        return productCatBrandPriority.get(domainId) != null ? null != ((Map)productCatBrandPriority.get(domainId)).get(seo) ? (Integer)((Map)productCatBrandPriority.get(domainId)).get(seo) : 1000 : 1000;
    }

    public Integer getProductBraPriority(String domainId, String seo) {
        return productBrandPriority.get(domainId) != null ? null != ((Map)productBrandPriority.get(domainId)).get(seo) ? (Integer)((Map)productBrandPriority.get(domainId)).get(seo) : 1000 : 1000;
    }

    public String getProductCatPath(String domainId, String seo) {
        return productCatPathMap.get(domainId) != null ? (String)((Map)productCatPathMap.get(domainId)).get(seo) : null;
    }

    public String getProductBrandSeo(String domainId, String seo) {
        return productBrandSeoMap.get(domainId) != null ? (String)((Map)productBrandSeoMap.get(domainId)).get(seo) : null;
    }

    public void setProductCatSeoAdd(String domainId, String key, String value) {
        if (productCatSeoMap.get(domainId) != null) {
            ((Map)productCatSeoMap.get(domainId)).put(key, value);
        }

    }

    public void setProductCatPathAdd(String domainId, String key, String value) {
        if (productCatPathMap.get(domainId) != null) {
            ((Map)productCatPathMap.get(domainId)).put(key, value);
        }

    }

    public void setProductBrandSeoAdd(String domainId, String key, String value) {
        if (productBrandSeoMap.get(domainId) != null) {
            ((Map)productBrandSeoMap.get(domainId)).put(key, value);
        }

    }

    public List<ProductCategory> getTopCat(String domainId) {
        return (List)topCat.get(domainId);
    }

    public Map<String, FeedMeta> getFeedMetaByDomainId(String domainId) {
        return (Map)feedMetaMap.get(domainId);
    }

    public Map<String, List<FeedMeta>> getFeedTagMapByDomainId(String domainId) {
        return (Map)feedTagMap.get(domainId);
    }

    public List<FeedMeta> getFeedTrendingTagMapByDomainId(String domainId, String key) {
        return feedTagMap.get(domainId) != null ? (List)((Map)feedTagMap.get(domainId)).get(key) : null;
    }

    public List<Product> getCatProductByName(String domainId, String catName) {
        return catProduct.get(domainId) != null ? (List)((Map)catProduct.get(domainId)).get(catName) : null;
    }

    public Map<String, List<ProductBrand>> getAllBrandByDomainId(String domainId) {
        return (Map)allBrand.get(domainId);
    }

    public Map<String, List<MenuData>> getMenuData(String domainId) {
        return (Map)menuDataMap.get(domainId);
    }

    public String getContent(String domainId) {
        return (String)homeContentMap.get(domainId);
    }
}
