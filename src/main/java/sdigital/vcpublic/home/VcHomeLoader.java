//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package sdigital.vcpublic.home;

import java.io.IOException;
import java.io.InputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.TreeMap;
import sdigital.pl.products.domains.Product;
import sdigital.pl.products.domains.ProductBrand;
import sdigital.pl.products.domains.ProductCategory;
import sdigital.pl.products.utilities.SolrDao;
import sdigital.pl.products.utilities.SolrUtils;
import sdigital.vcpublic.config.SystemConstant;
import wawo.io.IoClean;
import wawo.sql.Cleaner;
import wawo.sql.jdbc.Db;
import wawo.util.PropertyUtil;
public class VcHomeLoader {
    public VcHomeLoader() {
    }

    public static void generateCurrentDateForDomain(Db db) {
        String query = "SELECT TD.id AS D_Id,to_date(to_char((NOW() at TIME ZONE 'UTC' + TZ.utc_offset), 'YYYY-MM-DD'),'YYYY-MM-DD') as Curr_Date INTO TEMPORARY TABLE vc_domain_date FROM vc_domain TD LEFT JOIN pg_timezone_names TZ ON TZ.name = TD.country_name";
        removeCurrentDateForDomainTable(db);
        db.execute().ddl(query);
    }

    public static void removeCurrentDateForDomainTable(Db db) {
        String query = "DROP TABLE IF EXISTS vc_domain_date";
        db.execute().ddl(query);
    }

    public static void loadKeyPair(Db db, Map<String, String> map, String query) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString(1), rs.getString(2));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadDomains(Db db, Map<String, List<Domains>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TD.id,TD.domain_group_id,TD.theme_id,TD.name,TD.image,TD.domain_url,TD.fb_url,TD.twit_url,TD.pn_url,TD.gplus_url ,TD.analytics_code, TD.custom_headers,TD.certificate ,TD.test_certificate,TD.currency_type,TD.logo,logo_small,TC.name AS country_name, TD.scheme AS scheme, TD.theme_type As theme_type, TD.pop_status, TD.pop_head1, TD.pop_head2 FROM vc_domain TD, gl_country TC WHERE TD.publish = 1 AND TC.id = TD.country_id AND TC.publish = 1 ORDER BY TD.domain_group_id,TD.priority";
            rs = db.select().resultSet(query, (Object[])null);
            Map dupe = new HashMap();
            List<Domains> groupList = null;
            String prev = null;

            while(rs.next()) {
                Domains dm = new Domains();
                dm.setId(rs.getString("id"));
                dm.setDomainGroupId(rs.getString("domain_group_id"));
                if (dupe.get(dm.getDomainGroupId()) == null) {
                    if (prev != null) {
                        map.put(prev, groupList);
                    }

                    groupList = new ArrayList();
                    prev = dm.getDomainGroupId();
                    dupe.put(dm.getDomainGroupId(), "1");
                }

                dm.setThemeId(rs.getString("theme_id"));
                dm.setName(rs.getString("name"));
                dm.setImage(rs.getString("image"));
                dm.setDomainUrl(rs.getString("domain_url"));
                dm.setFbLink(rs.getString("fb_url"));
                dm.setGpLink(rs.getString("gplus_url"));
                dm.setTwLink(rs.getString("twit_url"));
                dm.setPnLink(rs.getString("pn_url"));
                dm.setAnalyticsCode(rs.getString("analytics_code"));
                dm.setCustomHeaders(rs.getString("custom_headers"));
                dm.setGuaranteeCertificate(rs.getString("certificate"));
                dm.setTestGuarantee(rs.getString("test_certificate"));
                dm.setCurrencyType(rs.getString("currency_type"));
                dm.setLogo(rs.getString("logo"));
                dm.setLogoMobile(rs.getString("logo_small"));
                dm.setCountryName(rs.getString("country_name"));
                dm.setScheme(rs.getString("scheme"));
                dm.setThemeType(rs.getString("theme_type"));
                dm.setPopSt(rs.getString("pop_status"));
                dm.setPopH1(rs.getString("pop_head1"));
                dm.setPopH2(rs.getString("pop_head2"));
                groupList.add(dm);
            }

            map.put(prev, groupList);
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }
    }

    public static void loadLanguages(Db db, Map<String, List<Language>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TL.id,TL.name,TL.code,TBL.is_default,TBL.domain_id FROM gl_language TL, bg_domain_language TBL WHERE TL.id = TBL.language_id AND TBL.publish = 1 ORDER BY TBL.domain_id,TBL.priority";
            rs = db.select().resultSet(query, (Object[])null);
            Map dupe = new HashMap();
            List<Language> langList = null;
            String prev = null;

            while(rs.next()) {
                Language l = new Language();
                l.setId(rs.getString("id"));
                l.setDomainId(rs.getString("domain_id"));
                if (dupe.get(l.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, langList);
                    }

                    langList = new ArrayList();
                    prev = l.getDomainId();
                    dupe.put(l.getDomainId(), "1");
                }

                l.setName(rs.getString("name"));
                l.setCode(rs.getString("code"));
                l.setIsDefault(rs.getBoolean("is_default"));
                langList.add(l);
            }

            map.put(prev, langList);
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }
    }

    public static void loadLabels(Db db, Map<String, Properties> map) throws SQLException, IOException {
        map.clear();
        ResultSet rs = null;
        InputStream ins = null;

        try {
            String query = "SELECT TL.id,TL.name,TL.code,TBL.is_default,TBL.domain_id FROM gl_language TL, bg_domain_language TBL WHERE TL.id = TBL.language_id AND TBL.publish = 1 ORDER BY TBL.domain_id,TBL.priority";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                ins = VcHomeLoader.class.getResourceAsStream("/lang_" + rs.getString("code") + ".ini");
                Properties paramProperties = PropertyUtil.getProperties(ins, "UTF-8");
                map.put(rs.getString("id"), paramProperties);
                IoClean.close(ins);
            }
        } finally {
            IoClean.close(ins);
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadConfig(Db db, Map<String, HomeConfig> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT id,domain_id,top_20,latest_voucher,latest_deals,similar_stotes,similar_categories,top_deals,number_peoples,updated_date,vote,favourite_stores,saved_coupons,expiry_date,search_box_position,store_list_row,social_media,guarantee_stamp,specials FROM vc_domain_config ORDER BY domain_id";

            HomeConfig hc;
            for(rs = db.select().resultSet(query, (Object[])null); rs.next(); map.put(rs.getString("domain_id"), hc)) {
                hc = new HomeConfig();
                hc.setId(rs.getString("id"));
                hc.setDomainId(rs.getString("domain_id"));
                hc.setTop20(rs.getString("top_20"));
                hc.setLatestVoucher(rs.getString("latest_voucher"));
                hc.setLatestDeals(rs.getString("latest_deals"));
                hc.setSimilarStotes(rs.getString("similar_stotes"));
                hc.setSimilarCategories(rs.getString("similar_categories"));
                hc.setTopDeals(rs.getString("top_deals"));
                hc.setNumberPeoples(rs.getString("number_peoples"));
                hc.setUpdatedDate(rs.getString("updated_date"));
                hc.setVote(rs.getString("vote"));
                hc.setFavouriteStores(rs.getString("favourite_stores"));
                hc.setSavedCoupons(rs.getString("saved_coupons"));
                hc.setExpiryDate(rs.getString("expiry_date"));
                hc.setSearchBoxPosition(rs.getString("search_box_position"));
                hc.setStoreListRow(rs.getString("store_list_row"));
                hc.setSocialMedia(rs.getString("social_media"));
                hc.setGuaranteeStamp(rs.getString("guarantee_stamp"));
                hc.setSpecials(rs.getString("specials"));
                if ("1".equals(rs.getString("top_20"))) {
                    hc.getTabConfigList().add("top");
                }

                if ("1".equals(rs.getString("latest_voucher"))) {
                    hc.getTabConfigList().add("voucher");
                }

                if ("1".equals(rs.getString("latest_deals"))) {
                    hc.getTabConfigList().add("deals");
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadSeoUrl(Db db, Map<String, List<SeoUrl>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TD.domain_id,TD.seo_url,TD.page_type,TD.language_id,TD.page_title,TD.meta_description,TD.meta_keywords,TD.pagetype_fk,TSC.store_id,TSC.category_id,TSB.store_id AS store_brand_id,TSB.brand_id,TD.archieved,TD.store_child_title,TD.store_child_desc, TD.top_content FROM vc_domain_seo_config TD LEFT JOIN bg_store_category TSC ON TSC.id = TD.pagetype_fk LEFT JOIN bg_brand_store TSB ON TSB.id = TD.pagetype_fk WHERE TD.publish = 1 ORDER BY TD.domain_id,TD.page_type";
            rs = db.select().resultSet(query, (Object[])null);
            List<SeoUrl> seoList = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                SeoUrl seo = new SeoUrl();
                seo.setDomainId(rs.getString("domain_id"));
                if (dupe.get(seo.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, seoList);
                    }

                    seoList = new ArrayList();
                    prev = seo.getDomainId();
                    dupe.put(seo.getDomainId(), "1");
                }

                seo.setPageType(rs.getString("page_type"));
                seo.setSeoUrl(rs.getString("seo_url"));
                seo.setLanguageId(rs.getString("language_id"));
                seo.setPageTitle(rs.getString("page_title"));
                seo.setMetaDesc(rs.getString("meta_description"));
                seo.setMetaKeyword(rs.getString("meta_keywords"));
                seo.setPageTypeFk(rs.getString("pagetype_fk"));
                seo.setStoreId(rs.getString("store_id"));
                seo.setCategoryId(rs.getString("category_id"));
                seo.setStoreBrandId(rs.getString("store_brand_id"));
                seo.setBrandId(rs.getString("brand_id"));
                seo.setArchived(rs.getString("archieved"));
                seo.setStoreChildTitle(rs.getString("store_child_title"));
                seo.setStoreChildDesc(rs.getString("store_child_desc"));
                seo.setTopContent(rs.getString("top_content"));
                seoList.add(seo);
                map.put(rs.getString("domain_id"), seoList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadSeoUrlStore(Db db, Map<String, List<SeoUrl>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TD.domain_id,TD.seo_url,TD.page_type,TD.language_id,TD.page_title,TD.meta_description,TD.meta_keywords,TD.pagetype_fk,TD.store_child_title,TD.store_child_desc,TSL.store_id,NULL as child_id,TD.archieved,TD.page_heading FROM vc_domain_seo_config TD ,vc_store_lang TSL WHERE TD.pagetype_fk = TSL.store_id AND TD.page_type=3 AND TD.language_id = TSL.language_id AND TD.archieved = 0 UNION SELECT TD.domain_id,TD.seo_url,TD.page_type,TD.language_id,TD.page_title,TD.meta_description,TD.meta_keywords,TD.pagetype_fk,TD.store_child_title,TD.store_child_desc,TSC.store_id,TSC.category_id as child_id,TD.archieved,TD.page_heading FROM vc_domain_seo_config TD ,bg_store_category TSC WHERE TD.pagetype_fk = TSC.id AND TD.page_type=53 AND TD.archieved = 0 UNION SELECT TD.domain_id,TD.seo_url,TD.page_type,TD.language_id,TD.page_title,TD.meta_description,TD.meta_keywords,TD.pagetype_fk,TD.store_child_title,TD.store_child_desc,TSB.store_id,TSB.brand_id as child_id,TD.archieved,TD.page_heading FROM vc_domain_seo_config TD ,bg_brand_store TSB WHERE TD.pagetype_fk = TSB.id  AND TD.page_type=52 AND TD.archieved = 0 ORDER BY 1";
            rs = db.select().resultSet(query, (Object[])null);
            List<SeoUrl> seoList = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                SeoUrl seo = new SeoUrl();
                seo.setDomainId(rs.getString("domain_id"));
                if (dupe.get(seo.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, seoList);
                    }

                    seoList = new ArrayList();
                    prev = seo.getDomainId();
                    dupe.put(seo.getDomainId(), "1");
                }

                seo.setPageType(rs.getString("page_type"));
                seo.setSeoUrl(rs.getString("seo_url"));
                seo.setLanguageId(rs.getString("language_id"));
                seo.setPageTitle(rs.getString("page_title"));
                seo.setMetaDesc(rs.getString("meta_description"));
                seo.setMetaKeyword(rs.getString("meta_keywords"));
                seo.setPageTypeFk(rs.getString("pagetype_fk"));
                seo.setStoreId(rs.getString("store_id"));
                seo.setCategoryId(rs.getString("child_id"));
                seo.setArchived(rs.getString("archieved"));
                seo.setStoreChildTitle(rs.getString("store_child_title"));
                seo.setStoreChildDesc(rs.getString("store_child_desc"));
                seo.setStoreChildHeading(rs.getString("page_heading"));
                seoList.add(seo);
                map.put(rs.getString("domain_id"), seoList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadStore(Db db, Map<String, List<Store>> map, Map<String, List<Store>> mapStore) throws SQLException {
        map.clear();
        mapStore.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TS.id,TS.affiliate_url,TS.affiliate_url,TS.domain_id,TS.image_small,TS.image_big,TS.banner_position,TS.banner_image_href,TS.banner_image_url,TS.banner_image_upload,TS.vote,TS.rating,TSL.language_id,TSL.name,TSL.seo_url AS seo_url11,TSL.about_store,TSL.meta_title,TSL.meta_description,TSL.meta_keywords,TSL.store_caption,TSL.news,TSL.reasons_to_use,TSL.how_to_use_coupon,TS.fb_link,TS.gp_link,TS.pn_link,TS.tw_link,TS.cod,TS.netbank,TSL.money_back,TSEO.seo_url,TSL.guarantee_info FROM vc_store TS,vc_store_lang TSL,vc_domain_seo_config TSEO WHERE TS.trash = 0 AND TS.popular_store = 1 AND TS.publish = 1 AND TS.id = TSL.store_id AND TSEO.pagetype_fk = TS.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TS.domain_id,TS.popular_store_priority,TS.priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<Store> storeList = null;
            List<Store> storeListId = null;
            Map dupe = new HashMap();
            Map dupeStore = new HashMap();
            String prev = null;
            String prevStore = null;

            while(rs.next()) {
                Store store = new Store();
                store.setId(rs.getString("id"));
                store.setDomainId(rs.getString("domain_id"));
                if (dupe.get(store.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, storeList);
                    }

                    storeList = new ArrayList();
                    prev = store.getDomainId();
                    dupe.put(store.getDomainId(), "1");
                }

                if (dupeStore.get(store.getId()) == null) {
                    if (prevStore != null) {
                        mapStore.put(prevStore, storeListId);
                    }

                    storeListId = new ArrayList();
                    prevStore = store.getId();
                    dupeStore.put(store.getId(), "1");
                }

                store.setAffiliateUrl(rs.getString("affiliate_url"));
                store.setStoreUrl(rs.getString("affiliate_url"));
                store.setImageSmall(rs.getString("image_small"));
                store.setImageBig(rs.getString("image_big"));
                store.setBannerPosition(rs.getString("banner_position"));
                store.setBannerImageHref(rs.getString("banner_image_href"));
                store.setBannerImageUrl(rs.getString("banner_image_url"));
                store.setBannerImageUpload(rs.getString("banner_image_upload"));
                store.setLanguageId(rs.getString("language_id"));
                store.setName(rs.getString("name"));
                store.setSeoUrl(rs.getString("seo_url"));
                store.setAboutStore(rs.getString("about_store"));
                store.setMetaTitle(rs.getString("meta_title"));
                store.setMetaDescription(rs.getString("meta_description"));
                store.setMetaKeywords(rs.getString("meta_keywords"));
                store.setStoreCaption(rs.getString("store_caption"));
                store.setVote(rs.getString("vote"));
                store.setRating(rs.getString("rating"));
                store.setNews(rs.getString("news"));
                store.setReason(rs.getString("reasons_to_use"));
                store.setHowToUse(rs.getString("how_to_use_coupon"));
                store.setFbLink(rs.getString("fb_link"));
                store.setGpLink(rs.getString("gp_link"));
                store.setPnLink(rs.getString("pn_link"));
                store.setTwLink(rs.getString("tw_link"));
                store.setCod(rs.getString("cod"));
                store.setNetBank(rs.getString("netbank"));
                store.setMoneyBack(rs.getString("money_back"));
                store.setGuaranteeInfo(rs.getString("guarantee_info"));
                storeList.add(store);
                storeListId.add(store);
                map.put(rs.getString("domain_id"), storeList);
                mapStore.put(rs.getString("id"), storeListId);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTopOffers(Db db, Map<String, List<VoucherDeals>> map, Map<String, List<VoucherDeals>> mapId) throws SQLException {
        map.clear();
        mapId.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO,vc_domain_date TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TST.popular_store = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TSEO.pagetype_fk = TST.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 AND TST.popular_store_priority <= 25 ORDER BY TST.domain_id DESC,TOF.used_count DESC,TOF.id DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            List<VoucherDeals> offerListId = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            Map dupeOfferId = new HashMap();
            String prev = null;
            String prevOfferId = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id") + rs.getString("offer_type")) == null) {
                    var10001 = rs.getString("store_id");
                    mapDupStore.put(var10001 + rs.getString("language_id") + rs.getString("offer_type"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    if (dupeOfferId.get(vd.getId()) == null) {
                        if (prevOfferId != null) {
                            mapId.put(prevOfferId, offerListId);
                        }

                        offerListId = new ArrayList();
                        prevOfferId = vd.getId();
                        dupeOfferId.put(vd.getId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    offerListId.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                    mapId.put(rs.getString("id"), offerListId);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadLatestVouchers(Db db, Map<String, List<VoucherDeals>> map, Map<String, List<VoucherDeals>> mapId) throws SQLException {
        map.clear();
        mapId.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.offer_type = 1 AND TOF.latest_voucher = 1 AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TSEO.pagetype_fk = TST.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,TOFL.modified_at DESC,TOF.id DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            List<VoucherDeals> offerListId = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            Map dupeOfferId = new HashMap();
            String prev = null;
            String prevOfferId = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id")) == null) {
                    mapDupStore.put(rs.getString("store_id") + rs.getString("language_id"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    if (dupeOfferId.get(vd.getId()) == null) {
                        if (prevOfferId != null) {
                            mapId.put(prevOfferId, offerListId);
                        }

                        offerListId = new ArrayList();
                        prevOfferId = vd.getId();
                        dupeOfferId.put(vd.getId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    offerListId.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                    mapId.put(rs.getString("id"), offerListId);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadLatestDeals(Db db, Map<String, List<VoucherDeals>> map, Map<String, List<VoucherDeals>> mapId) throws SQLException {
        map.clear();
        mapId.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url1,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST, vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.offer_type = 2 AND TOF.latest_deals = 1 AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id  AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,TOF.id DESC,TOFL.modified_at DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            List<VoucherDeals> offerListId = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            Map dupeOfferId = new HashMap();
            String prev = null;
            String prevOfferId = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id")) == null) {
                    mapDupStore.put(rs.getString("store_id") + rs.getString("language_id"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    if (dupeOfferId.get(vd.getId()) == null) {
                        if (prevOfferId != null) {
                            mapId.put(prevOfferId, offerListId);
                        }

                        offerListId = new ArrayList();
                        prevOfferId = vd.getId();
                        dupeOfferId.put(vd.getId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    offerListId.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                    mapId.put(rs.getString("id"), offerListId);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadBanner(Db db, Map<String, List<Banner>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT id,domain_id,language_id,banner_type,image,image_url,redirect_url,title FROM vc_banner WHERE publish = 1 ORDER BY domain_id,priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<Banner> bannerListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Banner banner = new Banner();
                banner.setId(rs.getString("id"));
                banner.setDomainId(rs.getString("domain_id"));
                if (dupe.get(banner.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, bannerListDomain);
                    }

                    bannerListDomain = new ArrayList();
                    prev = banner.getDomainId();
                    dupe.put(banner.getDomainId(), "1");
                }

                banner.setRedirectUrl(rs.getString("redirect_url"));
                banner.setImageUrl(rs.getString("image_url"));
                banner.setImage(rs.getString("image"));
                banner.setBannerType(rs.getString("banner_type"));
                banner.setLanguageId(rs.getString("language_id"));
                banner.setTitle(rs.getString("title"));
                bannerListDomain.add(banner);
                map.put(rs.getString("domain_id"), bannerListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadBannerPage(Db db, Map<String, List<BannerPage>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT id,domain_id,language_id,banner_type,banner_position,image,image_url,redirect_url,banner_script,title, affiliate FROM vc_banner_page WHERE publish = 1 ORDER BY domain_id,priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<BannerPage> bannerPageListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                BannerPage bannerPage = new BannerPage();
                bannerPage.setId(rs.getString("id"));
                bannerPage.setDomainId(rs.getString("domain_id"));
                if (dupe.get(bannerPage.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, bannerPageListDomain);
                    }

                    bannerPageListDomain = new ArrayList();
                    prev = bannerPage.getDomainId();
                    dupe.put(bannerPage.getDomainId(), "1");
                }

                bannerPage.setRedirectUrl(rs.getString("redirect_url"));
                bannerPage.setImageUrl(rs.getString("image_url"));
                bannerPage.setImage(rs.getString("image"));
                bannerPage.setBannerType(rs.getString("banner_type"));
                bannerPage.setBannerPosition(rs.getString("banner_position"));
                bannerPage.setLanguageId(rs.getString("language_id"));
                bannerPage.setBannerScript(rs.getString("banner_script"));
                bannerPage.setTitle(rs.getString("title"));
                bannerPage.setAffiliate(rs.getString("affiliate"));
                bannerPageListDomain.add(bannerPage);
                map.put(rs.getString("domain_id"), bannerPageListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadHomeCategories(Db db, Map<String, List<Category>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TC.id,TC.language_id,TC.name,TC.small_image,TBC.domain_id,TC.meta_title,TC.meta_description,TC.meta_keywords,TS.seo_url FROM gl_category TC, bg_category_domain TBC,vc_domain_seo_config TS WHERE TC.publish = 1 AND TBC.publish = 1 AND TBC.home_page_cat = 1 AND TC.parent_id = TBC.category_id AND TBC.category_id = TS.pagetype_fk AND TBC.domain_id = TS.domain_id AND TS.language_id = TC.language_id AND TS.page_type = 4 AND TS.archieved = 0 ORDER BY TBC.domain_id,TBC.top_menu_priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<Category> categoryListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Category category = new Category();
                category.setId(rs.getString("id"));
                category.setDomainId(rs.getString("domain_id"));
                if (dupe.get(category.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, categoryListDomain);
                    }

                    categoryListDomain = new ArrayList();
                    prev = category.getDomainId();
                    dupe.put(category.getDomainId(), "1");
                }

                category.setName(rs.getString("name"));
                category.setImage(rs.getString("small_image"));
                category.setLanguageId(rs.getString("language_id"));
                category.setTitle(rs.getString("meta_title"));
                category.setMetaDescription(rs.getString("meta_description"));
                category.setMetaKeyword(rs.getString("meta_keywords"));
                category.setSeoUrl(rs.getString("seo_url"));
                categoryListDomain.add(category);
                map.put(rs.getString("domain_id"), categoryListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadPopularCategories(Db db, Map<String, List<Category>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TBC.id AS bcid,TC.parent_id,TC.language_id,TC.name,TC.small_image,TBC.domain_id,TC.meta_title,TC.meta_description,TC.meta_keywords,TS.seo_url FROM gl_category TC, bg_category_domain TBC,vc_domain_seo_config TS WHERE TC.publish = 1 AND TBC.publish = 1 AND TBC.popular_cat = 1 AND TC.parent_id = TBC.category_id AND TBC.category_id = TS.pagetype_fk AND TBC.domain_id = TS.domain_id AND TS.language_id = TC.language_id AND TS.page_type = 4 AND TS.archieved = 0 ORDER BY TBC.domain_id,TBC.pop_menu_priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<Category> categoryListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Category category = new Category();
                category.setId(rs.getString("parent_id"));
                category.setDomainId(rs.getString("domain_id"));
                if (dupe.get(category.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, categoryListDomain);
                    }

                    categoryListDomain = new ArrayList();
                    prev = category.getDomainId();
                    dupe.put(category.getDomainId(), "1");
                }

                category.setBcid(rs.getString("bcid"));
                category.setName(rs.getString("name"));
                category.setImage(rs.getString("small_image"));
                category.setLanguageId(rs.getString("language_id"));
                category.setTitle(rs.getString("meta_title"));
                category.setMetaDescription(rs.getString("meta_description"));
                category.setMetaKeyword(rs.getString("meta_keywords"));
                category.setSeoUrl(rs.getString("seo_url"));
                categoryListDomain.add(category);
                map.put(rs.getString("domain_id"), categoryListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadPopularOffers(Db db, Map<String, List<VoucherDeals>> map, Map<String, List<VoucherDeals>> mapId) throws SQLException {
        map.clear();
        mapId.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "select * from ( SELECT distinct on(TOF.store_id || '' || TOB.category_id) (TOF.store_id || '' || TOB.category_id) as DC ,        TOF.used_count AS used_count_today,        TOF.id,        TST.domain_id,        TOFL.language_id,        TOB.category_id,        TOF.coupon_code,        TOF.offer_url,        TOF.start_date,        TOF.end_date,        TOF.offer_like,        TOF.offer_dislike,        TOF.view_type,        TOF.exclusive_coupon,        TST.image_small,        TST.image_big,        TST.affiliate_url,        TOFL.offer_heading,        TOFL.offer_description,        TOF.offer_type,        TOF.used_count,        TSL.name,        TSL.store_caption,        TSEO.seo_url,        TOF.store_id,        TOF.image,        TOF.always_on_top FROM vc_offer TOF,      vc_offer_lang TOFL,      vc_store TST,      bg_offer_category TOB,      vc_store_lang TSL,      vc_domain_seo_config TSEO,      vc_domain_date TD                      WHERE TOF.domain_id = TD.d_id   AND TOF.store_id = TST.id   AND TOF.id = TOFL.offer_id   AND TOF.start_date <= TD.Curr_Date   AND TOF.end_date >= TD.Curr_Date   AND TSL.store_id = TST.id   AND TOF.publish = 1   AND TOF.show_on_home = 1   AND TOF.trash = 0   AND TST.trash = 0   AND TOB.offer_id = TOF.id   AND TOFL.language_id = TSL.language_id   AND TST.PUBLISH = 1   AND TSEO.archieved = 0   AND TSEO.pagetype_fk = TST.id   AND TSEO.page_type = 3   AND TSEO.language_id = TSL.language_id   AND TOB.category_id in (select bg_category_domain.category_id from bg_category_domain where popular_cat=1 and TOF.domain_id=bg_category_domain.domain_id) ORDER BY (TOF.store_id || '' || TOB.category_id),TST.domain_id DESC,         TOB.category_id, offer_type, always_on_top DESC,     TOF.used_count DESC ) pp order by domain_id,category_id, offer_type, always_on_top DESC, used_count DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            List<VoucherDeals> offerListId = null;
            new HashMap();
            Map dupe = new HashMap();
            Map dupeOfferId = new HashMap();
            String prev = null;
            String prevOfferId = null;

            while(rs.next()) {
                VoucherDeals vd = new VoucherDeals();
                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                if (dupe.get(vd.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, offerListDomain);
                    }

                    offerListDomain = new ArrayList();
                    prev = vd.getDomainId();
                    dupe.put(vd.getDomainId(), "1");
                }

                if (dupeOfferId.get(vd.getId()) == null) {
                    if (prevOfferId != null) {
                        mapId.put(prevOfferId, offerListId);
                    }

                    offerListId = new ArrayList();
                    prevOfferId = vd.getId();
                    dupeOfferId.put(vd.getId(), "1");
                }

                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreId(rs.getString("store_id"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setCategoryId(rs.getString("category_id"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreCaption(rs.getString("store_caption"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                offerListDomain.add(vd);
                offerListId.add(vd);
                map.put(rs.getString("domain_id"), offerListDomain);
                mapId.put(rs.getString("id"), offerListId);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadSubCategory(Db db, Map<String, List<SubCategory>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TSC.id,TSC.parent_id,TC.id AS category_id,TBSD.domain_id,TSC.language_id,TSC.name,TSC.description,TBSD.bg_category_domain_id FROM gl_subcategory TSC, gl_category TC,bg_subcategory_domain TBSD WHERE TSC.publish = 1 AND TC.id = TSC.category_id AND TBSD.subcategory_id = TSC.parent_id AND TBSD.publish = 1 ORDER BY TBSD.domain_id,TBSD.bg_category_domain_id,TBSD.priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<SubCategory> subCatListId = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                SubCategory sbc = new SubCategory();
                sbc.setId(rs.getString("id"));
                sbc.setBcDid(rs.getString("bg_category_domain_id"));
                if (dupe.get(sbc.getBcDid()) == null) {
                    if (prev != null) {
                        map.put(prev, subCatListId);
                    }

                    subCatListId = new ArrayList();
                    prev = sbc.getBcDid();
                    dupe.put(sbc.getBcDid(), "1");
                }

                sbc.setCategoryId(rs.getString("category_id"));
                sbc.setDomainId(rs.getString("domain_id"));
                sbc.setLanguageId(rs.getString("language_id"));
                sbc.setName(rs.getString("name"));
                sbc.setDescription(rs.getString("description"));
                sbc.setParentId(rs.getString("parent_id"));
                subCatListId.add(sbc);
                map.put(rs.getString("bg_category_domain_id"), subCatListId);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTestimonial(Db db, Map<String, List<Testimonial>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT id,domain_id,name,description FROM vc_testimonials WHERE publish = 1 ORDER BY domain_id,priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<Testimonial> testimoListId = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Testimonial tm = new Testimonial();
                tm.setId(rs.getString("id"));
                tm.setDomainId(rs.getString("domain_id"));
                if (dupe.get(tm.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, testimoListId);
                    }

                    testimoListId = new ArrayList();
                    prev = tm.getDomainId();
                    dupe.put(tm.getDomainId(), "1");
                }

                tm.setDescription(rs.getString("description"));
                tm.setName(rs.getString("name"));
                testimoListId.add(tm);
                map.put(rs.getString("domain_id"), testimoListId);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadAllVD(Db db, Map<String, List<VoucherDeals>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type,TSL.store_caption,TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TOF.benefit_type,TOF.benefit_value,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST, vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date TD WHERE TOF.domain_id = TD.D_Id AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TST.publish = 1 AND TSEO.pagetype_fk = TST.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TOF.store_id DESC,TOFL.modified_at DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> storeListId = null;
            Map dupeStoreId = new HashMap();
            String prevStoreId = null;

            while(rs.next()) {
                VoucherDeals vd = new VoucherDeals();
                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setStoreId(rs.getString("store_id"));
                if (dupeStoreId.get(vd.getStoreId()) == null) {
                    if (prevStoreId != null) {
                        map.put(prevStoreId, storeListId);
                    }

                    storeListId = new ArrayList();
                    prevStoreId = vd.getStoreId();
                    dupeStoreId.put(vd.getStoreId(), "1");
                }

                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreCaption(rs.getString("store_caption"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setBenifitType(rs.getString("benefit_type"));
                vd.setBenifitValue(rs.getString("benefit_value"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }

                storeListId.add(vd);
                map.put(rs.getString("store_id"), storeListId);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static List<String> loadSimilarStores(Db db, String storeId, String domainId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psStore = null;
        ArrayList list = new ArrayList();

        try {
            String query = "SELECT TBS.store_id, COUNT(*) FROM bg_store_category TBS,vc_store TS WHERE  TBS.store_id !=? AND TS.domain_id = ? AND TS.publish = 1 AND TS.id=TBS.store_id AND TS.trash = 0 AND TS.popular_store = 1 AND TS.affiliate = 1 AND TBS.category_id IN(SELECT category_id FROM bg_store_category WHERE store_id = ?) GROUP BY TBS.store_id,TS.popular_store_priority ORDER BY 2 DESC,TS.popular_store_priority";
            psStore = db.select().getPreparedStatement(query);
            psStore.clearParameters();
            psStore.setInt(1, Integer.parseInt(storeId));
            psStore.setInt(2, Integer.parseInt(domainId));
            psStore.setInt(3, Integer.parseInt(storeId));
            rs = psStore.executeQuery();

            while(rs.next()) {
                list.add(rs.getString("store_id"));
            }
        } finally {
            Cleaner.close(psStore);
            Cleaner.close(rs);
            db.select().clean();
        }

        return list;
    }

    public static void loadCategoryTopStores(Db db, Map<String, List<CategoryStores>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT   vc_store.priority,   vc_store_lang.\"name\",   vc_store.popular_store,   vc_store.popular_store_priority,   gl_category.\"name\",   bg_store_category.category_id,   vc_store.domain_id,   vc_domain_seo_config.seo_url,   vc_domain_seo_config.page_type FROM   public.vc_store,   public.vc_store_lang,   public.bg_store_category,   public.gl_category,   public.vc_domain_seo_config WHERE vc_store.id = vc_store_lang.store_id AND vc_store.id = bg_store_category.store_id AND vc_store.domain_id = vc_domain_seo_config.domain_id AND vc_store.id = vc_domain_seo_config.pagetype_fk AND bg_store_category.category_id = gl_category.id AND vc_domain_seo_config.page_type = 3 and vc_store.popular_store = 1 and vc_domain_seo_config.publish=1 and vc_domain_seo_config.archieved=0 order by vc_store.domain_id,category_id,vc_store.popular_store_priority;";
            rs = db.select().resultSet(query, (Object[])null);
            List<CategoryStores> categoryTopStores = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                CategoryStores catStore = new CategoryStores();
                catStore.setDomainId(rs.getString("domain_id"));
                if (dupe.get(catStore.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, categoryTopStores);
                    }

                    categoryTopStores = new ArrayList();
                    prev = catStore.getDomainId();
                    dupe.put(catStore.getDomainId(), "1");
                }

                catStore.setCategoryId(rs.getString("category_id"));
                catStore.setCategoryName(rs.getString("name"));
                catStore.setPageType(rs.getString("page_type"));
                catStore.setPopularStore(rs.getString("popular_store"));
                catStore.setPopularStorePriority(rs.getString("popular_store_priority"));
                catStore.setPriority(rs.getString("priority"));
                catStore.setSeoUrl(rs.getString("seo_url"));
                catStore.setStoreName(rs.getString("name"));
                categoryTopStores.add(catStore);
                map.put(rs.getString("domain_id"), categoryTopStores);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadAllStores(Db db, Map<String, List<Store>> map, Map<String, List<Store>> mapStore) throws SQLException {
        map.clear();
        mapStore.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TS.id,TS.fb_link,TS.gp_link,TS.pn_link,TS.tw_link,TS.phone,TS.email,TS.affiliate_url,TS.store_url,TS.domain_id,TS.image_small,TS.image_big,TS.banner_position,TS.banner_image_href,TS.banner_image_url,TS.banner_image_upload,TS.vote,TS.rating,TS.affiliate,TSL.language_id,TSL.name,TSL.about_store,TSL.meta_title,TSL.meta_description,TSL.meta_keywords,TSEO.seo_url,TSL.how_to_use_coupon,TSL.guarantee_info,TSL.aboutus_title,TSL.reasons_to_use,TS.certified,TSL.store_caption, TS.top_content, TS.app_url, TS.ios_url FROM vc_store TS,vc_store_lang TSL, vc_domain_seo_config TSEO WHERE TS.trash = 0 AND TS.publish = 1 AND TS.id = TSL.store_id AND TSEO.archieved = 0 AND TSEO.pagetype_fk = TS.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id ORDER BY TS.domain_id,TS.priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<Store> storeList = null;
            List<Store> storeListId = null;
            Map dupe = new HashMap();
            Map dupeStore = new HashMap();
            String prev = null;
            String prevStore = null;

            while(rs.next()) {
                Store store = new Store();
                store.setId(rs.getString("id"));
                store.setDomainId(rs.getString("domain_id"));
                if (dupe.get(store.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, storeList);
                    }

                    storeList = new ArrayList();
                    prev = store.getDomainId();
                    dupe.put(store.getDomainId(), "1");
                }

                if (dupeStore.get(store.getId()) == null) {
                    if (prevStore != null) {
                        mapStore.put(prevStore, storeListId);
                    }

                    storeListId = new ArrayList();
                    prevStore = store.getId();
                    dupeStore.put(store.getId(), "1");
                }

                store.setAffiliateUrl(rs.getString("affiliate_url"));
                store.setStoreUrl(rs.getString("store_url"));
                store.setImageSmall(rs.getString("image_small"));
                store.setImageBig(rs.getString("image_big"));
                store.setBannerPosition(rs.getString("banner_position"));
                store.setBannerImageHref(rs.getString("banner_image_href"));
                store.setBannerImageUrl(rs.getString("banner_image_url"));
                store.setBannerImageUpload(rs.getString("banner_image_upload"));
                store.setLanguageId(rs.getString("language_id"));
                store.setName(rs.getString("name"));
                store.setSeoUrl(rs.getString("seo_url"));
                store.setAboutStore(rs.getString("about_store"));
                store.setMetaTitle(rs.getString("meta_title"));
                store.setMetaDescription(rs.getString("meta_description"));
                store.setMetaKeywords(rs.getString("meta_keywords"));
                store.setVote(rs.getString("vote"));
                store.setRating(rs.getString("rating"));
                store.setFbLink(rs.getString("fb_link"));
                store.setGpLink(rs.getString("gp_link"));
                store.setPnLink(rs.getString("pn_link"));
                store.setTwLink(rs.getString("tw_link"));
                store.setHowToUse(rs.getString("how_to_use_coupon"));
                store.setPhone(rs.getString("phone"));
                store.setEmail(rs.getString("email"));
                store.setGuaranteeInfo(rs.getString("guarantee_info"));
                store.setAboutTitle(rs.getString("aboutus_title"));
                store.setReason(rs.getString("reasons_to_use"));
                store.setCertified(rs.getString("certified"));
                store.setStoreCaption(rs.getString("store_caption"));
                store.setAffiliate(rs.getString("affiliate"));
                store.setTopContent(rs.getString("top_content"));
                store.setAppUrl(rs.getString("app_url"));
                store.setIosUrl(rs.getString("ios_url"));
                storeList.add(store);
                storeListId.add(store);
                map.put(rs.getString("domain_id"), storeList);
                mapStore.put(rs.getString("id"), storeListId);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadCategories(Db db, Map<String, List<Category>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT COALESCE(catOffer.offer_count,0) AS offer_count,TC.id,TBC.id AS bcid,TC.parent_id,TC.language_id,TC.name,TC.image,TC.small_image,TBC.domain_id,TC.meta_title,TC.meta_description,TC.meta_keywords,TS.seo_url FROM gl_category TC, bg_category_domain TBC LEFT OUTER JOIN (SELECT COUNT(BOC.offer_id) AS offer_count, BOC.category_id,TOF.domain_id FROM bg_offer_category BOC, vc_offer TOF,vc_domain_date TD WHERE TOF.id = BOC.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TOF.domain_id = TD.D_Id AND TOF.publish = 1 GROUP BY BOC.category_id,TOF.domain_id ORDER BY TOF.domain_id) AS catOffer ON catOffer.category_id = TBC.category_id AND catOffer.domain_id = TBC.domain_id,vc_domain_seo_config TS WHERE TC.publish = 1 AND TBC.publish = 1 AND TC.parent_id = TBC.category_id AND TBC.category_id = TS.pagetype_fk AND TBC.domain_id = TS.domain_id AND TS.language_id = TC.language_id AND TS.page_type = 4 AND TS.archieved = 0 ORDER BY TBC.domain_id,TBC.priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<Category> categoryListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Category category = new Category();
                category.setId(rs.getString("parent_id"));
                category.setDomainId(rs.getString("domain_id"));
                if (dupe.get(category.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, categoryListDomain);
                    }

                    categoryListDomain = new ArrayList();
                    prev = category.getDomainId();
                    dupe.put(category.getDomainId(), "1");
                }

                category.setBcid(rs.getString("bcid"));
                category.setName(rs.getString("name"));
                category.setImage(rs.getString("small_image"));
                category.setBigImage(rs.getString("image"));
                category.setLanguageId(rs.getString("language_id"));
                category.setTitle(rs.getString("meta_title"));
                category.setMetaDescription(rs.getString("meta_description"));
                category.setMetaKeyword(rs.getString("meta_keywords"));
                category.setSeoUrl(rs.getString("seo_url"));
                category.setOfferCount(rs.getString("offer_count"));
                categoryListDomain.add(category);
                map.put(rs.getString("domain_id"), categoryListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTopDeals(Db db, Map<String, List<VoucherDeals>> map, Map<String, List<VoucherDeals>> mapId) throws SQLException {
        map.clear();
        mapId.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.id,TOF.store_id,TSL.store_caption,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSEO.seo_url,TOF.image FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST, vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.offer_type = 2 AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TSEO.archieved = 0 AND TSEO.pagetype_fk = TST.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TST.popular_store = 1 ORDER BY TST.domain_id DESC,TOF.used_count DESC,TOF.id DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            List<VoucherDeals> offerListId = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            Map dupeOfferId = new HashMap();
            String prev = null;
            String prevOfferId = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id")) == null) {
                    mapDupStore.put(rs.getString("store_id") + rs.getString("language_id"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    if (dupeOfferId.get(vd.getId()) == null) {
                        if (prevOfferId != null) {
                            mapId.put(prevOfferId, offerListId);
                        }

                        offerListId = new ArrayList();
                        prevOfferId = vd.getId();
                        dupeOfferId.put(vd.getId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreCaption(rs.getString("store_caption"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    offerListDomain.add(vd);
                    offerListId.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                    mapId.put(rs.getString("id"), offerListId);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTop20Vouchers(Db db, Map<String, List<VoucherDeals>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO,vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TST.popular_store = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOF.offer_type = 1  AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 AND TST.popular_store_priority <= 25 ORDER BY TST.domain_id DESC,TOF.used_count DESC,TOF.id DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id")) == null) {
                    mapDupStore.put(rs.getString("store_id") + rs.getString("language_id"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTop20Offers(Db db, Map<String, List<VoucherDeals>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO, vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TST.popular_store = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOF.offer_type = 2 AND TOF.offer_subtype = 4 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 AND TST.popular_store_priority <= 25 ORDER BY TST.domain_id DESC,TOF.used_count DESC,TOF.id DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id")) == null) {
                    mapDupStore.put(rs.getString("store_id") + rs.getString("language_id"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTop20Deals(Db db, Map<String, List<VoucherDeals>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO, vc_domain_date TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TST.popular_store = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOF.offer_type = 2 AND TOF.offer_subtype = 5 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 AND TST.popular_store_priority <= 25 ORDER BY TST.domain_id DESC,TOF.used_count DESC,TOF.id DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id")) == null) {
                    mapDupStore.put(rs.getString("store_id") + rs.getString("language_id"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static List<String> loadSimilarStoresTopPages(Db db, String storeId, String domainId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psStore = null;
        ArrayList list = new ArrayList();

        try {
            String query = "SELECT TBS.store_id, COUNT(*) FROM bg_store_category TBS,vc_store TS WHERE TS.domain_id = ? AND TS.publish = 1 AND TS.id=TBS.store_id AND TS.trash = 0 AND TBS.category_id IN(SELECT category_id FROM bg_store_category WHERE store_id::text IN(SELECT unnest(string_to_array(?, ',')))) GROUP BY TBS.store_id ORDER BY 2 DESC LIMIT 6";
            psStore = db.select().getPreparedStatement(query);
            psStore.clearParameters();
            psStore.setInt(1, Integer.parseInt(domainId));
            psStore.setString(2, storeId);
            rs = psStore.executeQuery();

            while(rs.next()) {
                list.add(rs.getString("store_id"));
            }
        } finally {
            Cleaner.close(psStore);
            Cleaner.close(rs);
            db.select().clean();
        }

        return list;
    }

    public static void loadCategoryOffers(Db db, Map<String, Map<String, List<VoucherDeals>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOB.category_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,bg_offer_category TOB,vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date TD WHERE TOF.domain_id = TD.D_Id AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOB.offer_id = TOF.id AND TOFL.language_id = TSL.language_id AND TST.PUBLISH = 1 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,TOB.category_id DESC,TOFL.modified_at DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, String> mapDupStore = new HashMap();
            new HashMap();
            new HashMap();
            Map<String, List<VoucherDeals>> m = null;
            String prev = null;
            String prev1 = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id") + rs.getString("offer_type") + rs.getString("category_id")) == null) {
                    var10001 = rs.getString("store_id");
                    mapDupStore.put(var10001 + rs.getString("language_id") + rs.getString("offer_type") + rs.getString("category_id"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    vd.setCategoryId(rs.getString("category_id"));
                    if (!rs.getString("domain_id").equals(prev)) {
                        m = new HashMap();
                        offerListDomain = new ArrayList();
                    }

                    if (!rs.getString("category_id").equals(prev1)) {
                        offerListDomain = new ArrayList();
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    m.put(rs.getString("category_id"), offerListDomain);
                    map.put(rs.getString("domain_id"), m);
                    prev = rs.getString("domain_id");
                    prev1 = rs.getString("category_id");
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadEndingSoon(Db db, Map<String, List<VoucherDeals>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOF.end_date <= TD.Curr_Date+2 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,TOF.end_date,TOF.used_count DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id") + rs.getString("offer_type")) == null) {
                    var10001 = rs.getString("store_id");
                    mapDupStore.put(var10001 + rs.getString("language_id") + rs.getString("offer_type"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadExclusive(Db db, Map<String, List<VoucherDeals>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOF.exclusive_coupon = 1 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,TOFL.modified_at DESC,TOF.used_count DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id") + rs.getString("offer_type")) == null) {
                    var10001 = rs.getString("store_id");
                    mapDupStore.put(var10001 + rs.getString("language_id") + rs.getString("offer_type"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadExpiredVouchers(Db db, Map<String, List<VoucherDeals>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.end_date BETWEEN (TD.Curr_Date - INTERVAL '7 days') AND TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOF.offer_type = 1 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,TOF.end_date DESC,TOF.used_count DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id")) == null) {
                    mapDupStore.put(rs.getString("store_id") + rs.getString("language_id"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTotalCoupons(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TOF.domain_id,COUNT(*) AS totalCount FROM vc_offer TOF,vc_domain_date TD WHERE TOF.domain_id = TD.D_Id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date GROUP BY TOF.domain_id ORDER BY TOF.domain_id";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("domain_id"), rs.getString("totalCount"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTodaysTotalCoupons(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT domain_id,COUNT(domain_id) AS totalCount FROM (SELECT DISTINCT offer_id,domain_id FROM vc_used_coupon WHERE used_date >= (now() - '30 day'::INTERVAL)  ORDER BY domain_id) AS cnt GROUP BY cnt.domain_id";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("domain_id"), rs.getString("totalCount"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTotalStores(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT domain_id,COUNT(*) AS totalCount FROM vc_store WHERE trash = 0 AND publish = 1 GROUP BY domain_id ORDER BY domain_id";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("domain_id"), rs.getString("totalCount"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadExpiredVouchersStore(Db db, Map<String, List<VoucherDeals>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon, TOF.benefit_type, TOF.benefit_value, TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSEO.seo_url,TOF.image,TOFL.modified_at FROM vc_offer TOF,  vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.end_date < TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOF.offer_type = 1 AND TOF.coupon_code != '' AND TSEO.archieved = 0 AND TSEO.pagetype_fk = TST.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id ORDER BY TST.domain_id DESC,TOF.store_id,TOF.end_date DESC,TOF.used_count DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                VoucherDeals vd = new VoucherDeals();
                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setStoreId(rs.getString("store_id"));
                if (dupe.get(vd.getStoreId()) == null) {
                    if (prev != null) {
                        map.put(prev, offerListDomain);
                    }

                    offerListDomain = new ArrayList();
                    prev = vd.getStoreId();
                    dupe.put(vd.getStoreId(), "1");
                }

                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                vd.setBenifitType(rs.getString("benefit_type"));
                vd.setBenifitValue(rs.getString("benefit_value"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }

                offerListDomain.add(vd);
                map.put(rs.getString("store_id"), offerListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadContactAddress(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT domain_id,address FROM vc_domain_contact WHERE publish = 1 ORDER BY domain_id ";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("domain_id"), rs.getString("address"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadAboutUs(Db db, Map<String, List<AboutUs>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT domain_id,parent_id,language_id,title,description FROM vc_aboutus WHERE publish = 1 ORDER BY domain_id ";
            rs = db.select().resultSet(query, (Object[])null);
            List<AboutUs> aboutUsList = new ArrayList();

            for(String prev = null; rs.next(); prev = rs.getString("domain_id")) {
                AboutUs au = new AboutUs();
                if (!rs.getString("domain_id").equals(prev)) {
                    aboutUsList = new ArrayList();
                }

                au.setDomainId(rs.getString("domain_id"));
                au.setParentId(rs.getString("parent_id"));
                au.setLanguageId(rs.getString("language_id"));
                au.setTitle(rs.getString("title"));
                au.setDescription(rs.getString("description"));
                aboutUsList.add(au);
                map.put(rs.getString("domain_id"), aboutUsList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadAllStoresByName(Db db, Map<String, List<AllStores>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TS.id,TS.domain_id,'https://cdn3.paylesser.com'||TS.image_big AS img,TSL.language_id,TSL.name,TSL.seo_url AS seo_url11,'/' AS page_url,TSEO.seo_url FROM vc_store TS,vc_store_lang TSL,vc_domain TD,vc_domain_seo_config TSEO WHERE TS.trash = 0 AND TS.publish = 1 AND TS.id = TSL.store_id AND TD.id = TS.domain_id AND TSEO.pagetype_fk = TS.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TS.domain_id,TSL.language_id,TSL.name";
            rs = db.select().resultSet(query, (Object[])null);
            List<AllStores> allStoreList = null;
            AllStores store = null;
            Map dupeDomain = new HashMap();
            String prevDomain = null;
            Map dupeAbc = new HashMap();
            String prevAbc = null;
            String domainId = null;
            String key = null;

            while(true) {
                if (!rs.next()) {
                    if (domainId != null) {
                        allStoreList.add(store);
                        map.put(prevDomain, allStoreList);
                    }
                    break;
                }

                domainId = rs.getString("domain_id");
                key = domainId + rs.getString("language_id");
                if (dupeDomain.get(key) == null) {
                    if (prevAbc != null) {
                        allStoreList.add(store);
                        prevAbc = null;
                    }

                    if (prevDomain != null) {
                        map.put(prevDomain, allStoreList);
                    }

                    allStoreList = new ArrayList();
                    prevDomain = key;
                    dupeDomain.put(key, "1");
                }

                String name = rs.getString("name");
                String alphabet = name.substring(0, 1);
                if (alphabet.matches("-?\\d+(\\.\\d+)?")) {
                    alphabet = "0-9";
                }

                if (dupeAbc.get((alphabet + key).toLowerCase()) == null) {
                    if (prevAbc != null) {
                        allStoreList.add(store);
                    }

                    prevAbc = alphabet;
                    dupeAbc.put((alphabet + key).toLowerCase(), "1");
                    store = new AllStores(alphabet);
                }

                store.addContent(rs.getString("page_url") + rs.getString("seo_url"), rs.getString("img"), name);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadWeAreHiring(Db db, Map<String, List<Hiring>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT id,language_id,title,description,expiry FROM gl_hiring WHERE publish = 1 AND expiry >=current_date ORDER BY priority";
            rs = db.select().resultSet(query, (Object[])null);
            String key = null;
            ArrayList hiringList = new ArrayList();

            while(rs.next()) {
                Hiring hiring = new Hiring();
                Date expiry = rs.getDate("expiry");
                SimpleDateFormat ft = new SimpleDateFormat("dd MMMM yyyy");
                hiring.setExpiry(ft.format(expiry));
                hiring.setLanguageId(rs.getString("language_id"));
                hiring.setTitle(rs.getString("title"));
                hiring.setDescription(rs.getString("description"));
                hiringList.add(hiring);
                map.put("1", hiringList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadManagementTeam(Db db, Map<String, List<ManagementTeam>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT parent_id,domain_id,language_id,name,title,description,image,team_type,priority FROM vc_management_team WHERE publish = 1 ORDER BY domain_id, priority";
            rs = db.select().resultSet(query, (Object[])null);
            String key = null;
            List<ManagementTeam> managementList = new ArrayList();
            ManagementTeam management = null;

            while(rs.next()) {
                if (key == null || !rs.getString("domain_id").equals(key)) {
                    if (key != null && !rs.getString("domain_id").equals(key)) {
                        map.put(key, managementList);
                    }

                    managementList = new ArrayList();
                }

                key = rs.getString("domain_id");
                management = new ManagementTeam();
                management.setPriority(rs.getString("parent_id"));
                management.setDomainId(rs.getString("domain_id"));
                management.setLanguageId(rs.getString("language_id"));
                management.setName(rs.getString("name"));
                management.setTitle(rs.getString("title"));
                management.setDescription(rs.getString("description"));
                management.setImage(rs.getString("image"));
                management.setTeamType(rs.getString("team_type"));
                management.setPriority(rs.getString("priority"));
                managementList.add(management);
            }

            if (management != null) {
                map.put(key, managementList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadPrivacy(Db db, Map<String, List<Privacy>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT id,parent_id,domain_id,language_id,privacy FROM vc_privacy WHERE publish = 1 ORDER BY domain_id";
            rs = db.select().resultSet(query, (Object[])null);
            List<Privacy> privacyList = new ArrayList();

            for(String prev = null; rs.next(); prev = rs.getString("domain_id")) {
                Privacy p = new Privacy();
                if (!rs.getString("domain_id").equals(prev)) {
                    privacyList = new ArrayList();
                }

                p.setDomainId(rs.getString("domain_id"));
                p.setParentId(rs.getString("parent_id"));
                p.setLanguageId(rs.getString("language_id"));
                p.setPrivacy(rs.getString("privacy"));
                privacyList.add(p);
                map.put(rs.getString("domain_id"), privacyList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadAppId(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT id,fb_appid from vc_domain";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("id"), rs.getString("fb_appid"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadMarquee(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT id,marquee from vc_domain";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("id"), rs.getString("marquee"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadCouponNotWorked(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT domain_id,description from vc_howtouse where type = 1";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("domain_id"), rs.getString("description"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static List<VoucherDeals> loadSearchResult(Db db, String key, String domainId, String laungageId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psStore = null;
        List<VoucherDeals> list = new ArrayList();
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "(SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,\nTOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,\nTST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,\n TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url,1 AS s_type FROM vc_offer TOF, \nvc_offer_lang TOFL, vc_store TST,bg_offer_category TOB\n,vc_store_lang TSL,vc_domain_seo_config TSEO,gl_category TC,bg_category_domain TBCD WHERE TOF.store_id = TST.id AND TOF.id = TOFL.offer_id \nAND TOF.start_date <= current_date AND TOF.end_date >= current_date AND TSL.store_id = TST.id AND TOF.publish = 1 \nAND TOF.trash = 0 AND TST.trash = 0 AND TOB.offer_id = TOF.id AND TOFL.language_id = TSL.language_id AND TST.PUBLISH = 1 \nAND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id \nAND TC.parent_id = TOB.category_id AND TC.language_id = TOFL.language_id AND TSEO.archieved = 0 \nAND TST.domain_id = ? AND TSL.language_id = ? AND LOWER(TC.name) LIKE LOWER(?) \nAND TBCD.category_id = TC.id ORDER BY TST.domain_id DESC,TOB.category_id DESC,TOF.used_count DESC) \n UNION \n(SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,\n TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,\n TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,\n TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url,2 AS s_type FROM vc_offer TOF, \nvc_offer_lang TOFL, vc_store TST\n,vc_store_lang TSL,vc_domain_seo_config TSEO WHERE TOF.store_id = TST.id AND TOF.id = TOFL.offer_id \nAND TOF.start_date <= current_date AND TOF.end_date >= current_date AND TSL.store_id = TST.id AND TOF.publish = 1 \nAND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TST.PUBLISH = 1 \nAND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 \nAND TST.domain_id = ? AND TSL.language_id = ? AND LOWER(TSL.name) LIKE LOWER(?)\n ORDER BY TST.domain_id DESC,TOF.used_count DESC)\nUNION \n(SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id, TOF.coupon_code,\nTOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small, TST.image_big,TST.affiliate_url,\nTOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name, TSL.seo_url AS seo_url11,TOF.image,\nTOFL.modified_at,TSEO.seo_url,3 AS s_type FROM vc_offer TOF,  \nvc_offer_lang TOFL, vc_store TST,bg_brand_offer TOB,vc_store_lang TSL,\ngl_brand TB, bg_brand_store TBS,vc_domain_seo_config TSEO WHERE TSEO.page_type = 52 AND TSEO.archieved = 0 \nAND TSEO.pagetype_fk =TBS.id AND TBS.store_id = TST.id AND TBS.brand_id = TB.parent_id \nAND TSEO.language_id = TB.language_id AND TB.publish = 1 AND TSEO.language_id = TSL.language_id AND TSL.store_id = TST.id \nAND TST.publish = 1 AND TST.trash = 0 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id \nAND TOFL.language_id = TSL.language_id AND TOF.publish = 1 AND TOF.trash = 0 AND TOB.offer_id = TOF.id \nAND TBS.brand_id = TOB.brand_id AND TOF.start_date <= current_date AND TOF.end_date >= current_date \nAND TST.domain_id = ? AND TSL.language_id = ? AND LOWER(TB.name) LIKE LOWER(?)\nORDER BY TST.domain_id DESC,TST.id DESC,TOB.brand_id DESC,TOFL.modified_at DESC LIMIT 30)";
            psStore = db.select().getPreparedStatement(query);
            psStore.clearParameters();
            psStore.setInt(1, Integer.parseInt(domainId));
            psStore.setInt(2, Integer.parseInt(laungageId));
            psStore.setString(3, "%" + key + "%");
            psStore.setInt(4, Integer.parseInt(domainId));
            psStore.setInt(5, Integer.parseInt(laungageId));
            psStore.setString(6, "%" + key + "%");
            psStore.setInt(7, Integer.parseInt(domainId));
            psStore.setInt(8, Integer.parseInt(laungageId));
            psStore.setString(9, "%" + key + "%");

            VoucherDeals vd;
            for(rs = psStore.executeQuery(); rs.next(); ((List)list).add(vd)) {
                vd = new VoucherDeals();
                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setStoreId(rs.getString("store_id"));
                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setSearchType(rs.getString("s_type"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }
            }
        } finally {
            Cleaner.close(psStore);
            Cleaner.close(rs);
            db.select().clean();
        }

        if (((List)list).size() == 0) {
            list = loadOfferSearchResult(db, key, domainId, laungageId);
        }

        return (List)list;
    }

    public static List<VoucherDeals> loadOfferSearchResult(Db db, String key, String domainId, String laungageId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psStore = null;
        List<VoucherDeals> list = new ArrayList();
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            key = key.toLowerCase();
            String[] parts = key.split(" ");
            if (key.contains("coupon") || key.contains("coupons") || key.contains("voucher") || key.contains("vouchers")) {
                key = parts[0];
            }

            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id, TOF.coupon_code,\nTOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small, TST.image_big,TST.affiliate_url,\nTOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name, TSL.seo_url AS seo_url11,TOF.image,\nTOFL.modified_at,TSEO.seo_url,3 AS s_type FROM vc_offer TOF,\nvc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO WHERE TOF.store_id = TST.id \nAND TOF.id = TOFL.offer_id AND TOF.start_date <= current_date AND TOF.end_date >= current_date AND TSL.store_id = TST.id \nAND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TST.PUBLISH = 1 \nAND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 AND \nLOWER(TOFL.offer_heading) LIKE LOWER(?) AND LOWER(TOFL.offer_description) LIKE LOWER(?) AND TST.domain_id = ? AND TSL.language_id = ? \nORDER BY TST.domain_id DESC,TOFL.modified_at DESC";
            psStore = db.select().getPreparedStatement(query);
            psStore.clearParameters();
            psStore.setString(1, "%" + key + "%");
            psStore.setString(2, "%" + key + "%");
            psStore.setInt(3, Integer.parseInt(domainId));
            psStore.setInt(4, Integer.parseInt(laungageId));

            VoucherDeals vd;
            for(rs = psStore.executeQuery(); rs.next(); list.add(vd)) {
                vd = new VoucherDeals();
                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setStoreId(rs.getString("store_id"));
                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setSearchType(rs.getString("s_type"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }
            }
        } finally {
            Cleaner.close(psStore);
            Cleaner.close(rs);
            db.select().clean();
        }

        return list;
    }

    public static void loadStoreCategoryOffers(Db db, Map<String, Map<String, List<VoucherDeals>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TAB2.used_count_today,TAB2.OFFID id,TAB2.SID store_id,TAB2.DID domain_id,TAB2.LANID language_id,TAB2.CID category_id,TAB2.C_CODE coupon_code,TAB2.O_URL offer_url,TAB2.S_DATE start_date,TAB2.E_DATE end_date,TAB2.O_LIKE offer_like,TAB2.O_DISLIKE offer_dislike, TAB2.V_TYPE view_type, TAB2.E_COUPON exclusive_coupon, TAB2.IMG_SMALL image_small,TAB2.IMAGE_BIG image_big,TAB2.AFF_URL affiliate_url,TAB2.O_HEADING offer_heading,TAB2.O_DESC offer_description,TAB2.O_TYPE offer_type,TAB2.USD_CNT used_count,TAB2.name,TAB2.SEO_URL11,TAB2.IMG image,TAB2.MOD_AT modified_at,TAB2.BEN_TYPE benefit_type,TAB2.BEN_VAL benefit_value,TAB1.SEOURL seo_url,TAB1.BNAME AS brand_name FROM (SELECT TCS.store_id SID,TC.parent_id CID,TC.name AS BNAME,TC.language_id LANID,TSEO.seo_url SEOURL FROM gl_category TC,bg_store_category TCS,vc_domain_seo_config TSEO WHERE TC.parent_id = TCS.category_id  AND TC.publish = 1 AND TC.language_id =TSEO.language_id AND TCS.id = TSEO.pagetype_fk AND TSEO.page_type = 53 AND TSEO.archieved = 0) AS TAB1,(SELECT TOF.used_count AS used_count_today,TOF.id OFFID,TOF.store_id SID,TST.domain_id DID,TOFL.language_id LANID,TOC.category_id CID,TOF.coupon_code C_CODE,TOF.offer_url O_URL,TOF.start_date S_DATE,TOF.end_date E_DATE,TOF.offer_like O_LIKE,TOF.offer_dislike O_DISLIKE, TOF.view_type V_TYPE, TOF.exclusive_coupon E_COUPON, TST.image_small IMG_SMALL,TST.image_big IMAGE_BIG,TST.affiliate_url AFF_URL,TOFL.offer_heading O_HEADING,TOFL.offer_description O_DESC,TOF.offer_type O_TYPE,TOF.used_count USD_CNT,TSL.name,TSL.seo_url AS SEO_URL11,TOF.image IMG,TOFL.modified_at MOD_AT,TOF.benefit_type BEN_TYPE,TOF.benefit_value BEN_VAL FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,bg_offer_category TOC,vc_store_lang TSL, vc_domain_date TD WHERE TOF.id = TOFL.offer_id AND TOF.store_id = TST.id AND TOF.id = TOC.offer_id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.id = TSL.store_id AND TST.publish = 1 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOF.domain_id = TD.D_Id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date) TAB2 WHERE TAB1.SID = TAB2.SID AND TAB1.CID = TAB2.CID AND TAB1.LANID = TAB2.LANID ORDER BY domain_id DESC,store_id DESC,category_id DESC,start_date DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, List<VoucherDeals>> m = null;
            String prev = null;

            for(String prev1 = null; rs.next(); prev1 = rs.getString("category_id")) {
                VoucherDeals vd = new VoucherDeals();
                if (!rs.getString("store_id").equals(prev)) {
                    m = new HashMap();
                    offerListDomain = new ArrayList();
                }

                if (!rs.getString("category_id").equals(prev1)) {
                    offerListDomain = new ArrayList();
                }

                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setCategoryId(rs.getString("category_id"));
                vd.setStoreId(rs.getString("store_id"));
                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setBenifitType(rs.getString("benefit_type"));
                vd.setBenifitValue(rs.getString("benefit_value"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }

                offerListDomain.add(vd);
                m.put(rs.getString("category_id"), offerListDomain);
                map.put(rs.getString("store_id"), m);
                prev = rs.getString("store_id");
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadSearchKey(Db db, Map<String, List<SearchKey>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "(SELECT TSL.language_id,TSL.name,TS.domain_id FROM vc_store_lang TSL,vc_store TS WHERE TS.id=TSL.store_id AND TS.publish = 1 ORDER BY TS.domain_id DESC,TSL.name) UNION ALL (SELECT TC.language_id,TC.name,TBC.domain_id FROM gl_category TC,bg_category_domain TBC WHERE TBC.category_id = TC.parent_id ORDER BY TBC.domain_id DESC,TC.name) UNION ALL (SELECT TB.language_id,TB.name,TBD.domain_id FROM gl_brand TB,bg_brand_domain TBD WHERE TBD.brand_id = TB.parent_id ORDER BY TBD.domain_id,TB.name)";
            rs = db.select().resultSet(query, (Object[])null);
            List<SearchKey> skList = new ArrayList();
            Object var6 = null;

            while(rs.next()) {
                SearchKey sk = new SearchKey();
                sk.setName(rs.getString("name"));
                sk.setLanguageId(rs.getString("language_id"));
                sk.setDomainId(rs.getString("domain_id"));
                skList.add(sk);
                map.put("1", skList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadStoreBrandOffers(Db db, Map<String, Map<String, List<VoucherDeals>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOB.brand_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TOF.benefit_type,TOF.benefit_value,TSEO.seo_url,TB.name AS brand_name FROM vc_offer TOF,  vc_offer_lang TOFL, vc_store TST,bg_brand_offer TOB,vc_store_lang TSL,gl_brand TB, bg_brand_store TBS,vc_domain_seo_config TSEO ,vc_domain_date TD WHERE TOF.domain_id = TD.D_Id AND TSEO.page_type = 52 AND TSEO.archieved = 0 AND TSEO.pagetype_fk =TBS.id AND TBS.store_id = TST.id AND TBS.brand_id = TB.parent_id AND TSEO.language_id = TB.language_id AND TB.publish = 1 AND TSEO.language_id = TSL.language_id AND TSL.store_id = TST.id AND TST.publish = 1 AND TST.trash = 0 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOFL.language_id = TSL.language_id AND TOF.publish = 1 AND TOF.trash = 0 AND TOB.offer_id = TOF.id AND TBS.brand_id = TOB.brand_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date ORDER BY TST.domain_id DESC,TST.id DESC,TOB.brand_id DESC,TOF.start_date DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, List<VoucherDeals>> m = null;
            String prev = null;

            for(String prev1 = null; rs.next(); prev1 = rs.getString("brand_id")) {
                VoucherDeals vd = new VoucherDeals();
                if (!rs.getString("store_id").equals(prev)) {
                    m = new HashMap();
                    offerListDomain = new ArrayList();
                }

                if (!rs.getString("brand_id").equals(prev1)) {
                    offerListDomain = new ArrayList();
                }

                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setBrandId(rs.getString("brand_id"));
                vd.setStoreId(rs.getString("store_id"));
                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setBenifitType(rs.getString("benefit_type"));
                vd.setBenifitValue(rs.getString("benefit_value"));
                vd.setBrandName(rs.getString("brand_name"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }

                offerListDomain.add(vd);
                m.put(rs.getString("brand_id"), offerListDomain);
                map.put(rs.getString("store_id"), m);
                prev = rs.getString("store_id");
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadBrandOffers(Db db, Map<String, Map<String, List<VoucherDeals>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOB.brand_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,bg_brand_offer TOB,vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOB.offer_id = TOF.id AND TOFL.language_id = TSL.language_id AND TST.PUBLISH = 1 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,TOB.brand_id DESC,TOF.used_count DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            new HashMap();
            new HashMap();
            Map<String, List<VoucherDeals>> m = null;
            String prev = null;

            for(String prev1 = null; rs.next(); prev1 = rs.getString("brand_id")) {
                VoucherDeals vd = new VoucherDeals();
                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setBrandId(rs.getString("brand_id"));
                if (!rs.getString("domain_id").equals(prev)) {
                    m = new HashMap();
                    offerListDomain = new ArrayList();
                }

                if (!rs.getString("brand_id").equals(prev1)) {
                    offerListDomain = new ArrayList();
                }

                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreId(rs.getString("store_id"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }

                offerListDomain.add(vd);
                m.put(rs.getString("brand_id"), offerListDomain);
                map.put(rs.getString("domain_id"), m);
                prev = rs.getString("domain_id");
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadBrands(Db db, Map<String, List<Brand>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TB.id,TB.language_id,TB.name,TBD.domain_id,TSEO.page_title,TSEO.meta_description,TSEO.meta_keywords,TSEO.seo_url FROM gl_brand TB,bg_brand_domain TBD,vc_domain_seo_config TSEO WHERE TB.publish = 1 AND TBD.publish = 1 AND TB.parent_id = TBD.brand_id AND TBD.brand_id = TSEO.pagetype_fk AND TBD.domain_id = TSEO.domain_id AND TSEO.language_id = TB.language_id AND TSEO.page_type = 51 AND TSEO.archieved = 0 ORDER BY TBD.domain_id";
            rs = db.select().resultSet(query, (Object[])null);
            List<Brand> brandListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Brand brand = new Brand();
                brand.setId(rs.getString("id"));
                brand.setDomainId(rs.getString("domain_id"));
                if (dupe.get(brand.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, brandListDomain);
                    }

                    brandListDomain = new ArrayList();
                    prev = brand.getDomainId();
                    dupe.put(brand.getDomainId(), "1");
                }

                brand.setName(rs.getString("name"));
                brand.setLanguageId(rs.getString("language_id"));
                brand.setTitle(rs.getString("page_title"));
                brand.setMetaDescription(rs.getString("meta_description"));
                brand.setMetaKeyword(rs.getString("meta_keywords"));
                brand.setSeoUrl(rs.getString("seo_url"));
                brandListDomain.add(brand);
                map.put(rs.getString("domain_id"), brandListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadAllBrandsByName(Db db, Map<String, List<AllBrands>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TB.id,TB.language_id,'http://cdn3.vouchercodes.in'||TB.image AS img,TB.name,TBD.domain_id,TSEO.page_title,TSEO.meta_description,TSEO.meta_keywords,TSEO.seo_url,'http://'||TD.domain_url||'/' AS page_url FROM gl_brand TB,bg_brand_domain TBD,vc_domain_seo_config TSEO,vc_domain TD WHERE TB.publish = 1 AND TBD.publish = 1 AND TB.parent_id = TBD.brand_id AND TBD.brand_id = TSEO.pagetype_fk AND TBD.domain_id = TSEO.domain_id AND TD.id = TSEO.domain_id AND TSEO.language_id = TB.language_id AND TSEO.page_type = 51 AND TSEO.archieved = 0 ORDER BY TBD.domain_id,TB.language_id,TB.name";
            rs = db.select().resultSet(query, (Object[])null);
            List<AllBrands> allBrandList = null;
            AllBrands brands = null;
            Map dupeDomain = new HashMap();
            String prevDomain = null;
            Map dupeAbc = new HashMap();
            String prevAbc = null;
            String domainId = null;
            String key = null;

            while(true) {
                if (!rs.next()) {
                    if (domainId != null) {
                        allBrandList.add(brands);
                        map.put(prevDomain, allBrandList);
                    }
                    break;
                }

                domainId = rs.getString("domain_id");
                key = domainId + rs.getString("language_id");
                if (dupeDomain.get(key) == null) {
                    if (prevAbc != null) {
                        allBrandList.add(brands);
                        prevAbc = null;
                    }

                    if (prevDomain != null) {
                        map.put(prevDomain, allBrandList);
                    }

                    allBrandList = new ArrayList();
                    prevDomain = key;
                    dupeDomain.put(key, "1");
                }

                String name = rs.getString("name");
                String alphabet = name.substring(0, 1);
                if (alphabet.matches("-?\\d+(\\.\\d+)?")) {
                    alphabet = "0-9";
                }

                if (dupeAbc.get(alphabet + key) == null) {
                    if (prevAbc != null) {
                        allBrandList.add(brands);
                    }

                    prevAbc = alphabet;
                    dupeAbc.put(alphabet + key, "1");
                    brands = new AllBrands(alphabet);
                }

                brands.addContent(rs.getString("page_url") + rs.getString("seo_url"), rs.getString("img"), name);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadStoreCatName(Db db, Map<String, List<StoreCategory>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TC.id,TC.parent_id,TBC.domain_id,TC.name,TSC.id,TSC.store_id,TC.language_id,TSEO.seo_url,TSEO.page_title,TSEO.meta_description,TSEO.meta_keywords FROM gl_category TC,bg_category_domain TBC, bg_store_category TSC,vc_domain_seo_config TSEO WHERE TC.parent_id = TSC.category_id AND TSEO.domain_id = TBC.domain_id AND TC.parent_id = TBC.category_id AND TC.language_id = TSEO.language_id AND TSEO.pagetype_fk = TSC.id AND TSEO.page_type = 53 AND TSEO.archieved = 0 AND TBC.publish = 1 AND TSEO.publish = 1 ORDER BY TBC.domain_id,TSC.store_id";
            rs = db.select().resultSet(query, (Object[])null);
            List<StoreCategory> catListStore = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                StoreCategory storeCat = new StoreCategory();
                storeCat.setId(rs.getString("id"));
                storeCat.setDomainId(rs.getString("domain_id"));
                storeCat.setStoreId(rs.getString("store_id"));
                if (dupe.get(storeCat.getStoreId()) == null) {
                    if (prev != null) {
                        map.put(prev, catListStore);
                    }

                    catListStore = new ArrayList();
                    prev = storeCat.getStoreId();
                    dupe.put(storeCat.getStoreId(), "1");
                }

                storeCat.setParentId(rs.getString("parent_id"));
                storeCat.setName(rs.getString("name"));
                storeCat.setLanguageId(rs.getString("language_id"));
                storeCat.setPageTitle(rs.getString("page_title"));
                storeCat.setMetaDescription(rs.getString("meta_description"));
                storeCat.setMetaKeywords(rs.getString("meta_keywords"));
                storeCat.setSeoUrl(rs.getString("seo_url"));
                catListStore.add(storeCat);
                map.put(rs.getString("store_id"), catListStore);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadStoreCatNameForSimilarCoupon(Db db, Map<String, List<StoreCategory>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TC.id,TC.parent_id,TBC.domain_id,TC.name,TSC.id,TSC.store_id,TC.language_id,TSEO.seo_url,TSEO.page_title,TSEO.meta_description,TSEO.meta_keywords FROM gl_category TC,bg_category_domain TBC, bg_store_category TSC,vc_domain_seo_config TSEO WHERE TC.parent_id = TSC.category_id AND TSEO.domain_id = TBC.domain_id AND TC.parent_id = TBC.category_id AND TC.language_id = TSEO.language_id AND TSEO.pagetype_fk = TSC.id AND TSEO.page_type = 53 AND TSEO.archieved = 0 ORDER BY TBC.domain_id,TSC.store_id";
            rs = db.select().resultSet(query, (Object[])null);
            List<StoreCategory> catListStore = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                StoreCategory storeCat = new StoreCategory();
                storeCat.setId(rs.getString("id"));
                storeCat.setDomainId(rs.getString("domain_id"));
                storeCat.setStoreId(rs.getString("store_id"));
                if (dupe.get(storeCat.getStoreId()) == null) {
                    if (prev != null) {
                        map.put(prev, catListStore);
                    }

                    catListStore = new ArrayList();
                    prev = storeCat.getStoreId();
                    dupe.put(storeCat.getStoreId(), "1");
                }

                storeCat.setParentId(rs.getString("parent_id"));
                storeCat.setName(rs.getString("name"));
                storeCat.setLanguageId(rs.getString("language_id"));
                storeCat.setPageTitle(rs.getString("page_title"));
                storeCat.setMetaDescription(rs.getString("meta_description"));
                storeCat.setMetaKeywords(rs.getString("meta_keywords"));
                storeCat.setSeoUrl(rs.getString("seo_url"));
                catListStore.add(storeCat);
                map.put(rs.getString("store_id"), catListStore);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadStoreBrandName(Db db, Map<String, List<StoreBrand>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TB.id,TB.parent_id,TBB.domain_id,TB.name,TSB.id AS store_cat_id,TSB.store_id,TB.language_id,TSEO.seo_url,TSEO.page_title,TSEO.meta_description,TSEO.meta_keywords FROM gl_brand TB,bg_brand_domain TBB, bg_brand_store TSB,vc_domain_seo_config TSEO WHERE TB.parent_id = TSB.brand_id AND TSEO.domain_id = TBB.domain_id AND TB.parent_id = TBB.brand_id AND TB.language_id = TSEO.language_id AND TSEO.pagetype_fk = TSB.id AND TSEO.page_type = 52 AND TSEO.archieved = 0 ORDER BY TBB.domain_id,TSB.store_id";
            rs = db.select().resultSet(query, (Object[])null);
            List<StoreBrand> brandListStore = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                StoreBrand storeBrand = new StoreBrand();
                storeBrand.setId(rs.getString("id"));
                storeBrand.setParentId(rs.getString("parent_id"));
                storeBrand.setDomainId(rs.getString("domain_id"));
                storeBrand.setStoreId(rs.getString("store_id"));
                if (dupe.get(storeBrand.getStoreId()) == null) {
                    if (prev != null) {
                        map.put(prev, brandListStore);
                    }

                    brandListStore = new ArrayList();
                    prev = storeBrand.getStoreId();
                    dupe.put(storeBrand.getStoreId(), "1");
                }

                storeBrand.setName(rs.getString("name"));
                storeBrand.setLanguageId(rs.getString("language_id"));
                storeBrand.setPageTitle(rs.getString("page_title"));
                storeBrand.setMetaDescription(rs.getString("meta_description"));
                storeBrand.setMetaKeywords(rs.getString("meta_keywords"));
                storeBrand.setSeoUrl(rs.getString("seo_url"));
                brandListStore.add(storeBrand);
                map.put(rs.getString("store_id"), brandListStore);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static List<VoucherDeals> loadCouponDetails(Db db, String offerId, String laungageId, String domainId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psStore = null;
        List<VoucherDeals> list = new ArrayList();
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url,TOFL.terms_and_conditions FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO WHERE TST.publish = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TOF.id = ? AND TOFL.language_id = ? AND TST.domain_id = ? AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,TOF.used_count DESC,TOF.id DESC";
            psStore = db.select().getPreparedStatement(query);
            psStore.clearParameters();
            psStore.setInt(1, Integer.parseInt(offerId));
            psStore.setInt(2, Integer.parseInt(laungageId));
            psStore.setInt(3, Integer.parseInt(domainId));

            VoucherDeals vd;
            for(rs = psStore.executeQuery(); rs.next(); list.add(vd)) {
                vd = new VoucherDeals();
                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setStoreId(rs.getString("store_id"));
                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.settAndc(rs.getString("terms_and_conditions"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }
            }
        } finally {
            Cleaner.close(psStore);
            Cleaner.close(rs);
            db.select().clean();
        }

        return list;
    }

    public static void loadFaq(Db db, Map<String, List<Faq>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT parent_id, domain_id, language_id, question, answer FROM vc_faq WHERE publish = 1 ORDER BY domain_id, priority";
            rs = db.select().resultSet(query, (Object[])null);
            Map dupe = new HashMap();
            List<Faq> faqList = null;
            String prev = null;

            while(rs.next()) {
                Faq fq = new Faq();
                fq.setDomainId(rs.getString("domain_id"));
                if (dupe.get(fq.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, faqList);
                    }

                    faqList = new ArrayList();
                    prev = fq.getDomainId();
                    dupe.put(fq.getDomainId(), "1");
                }

                fq.setParentId(rs.getString("parent_id"));
                fq.setLanguageId(rs.getString("language_id"));
                fq.setQuestion(rs.getString("question"));
                fq.setAnswer(rs.getString("answer"));
                faqList.add(fq);
                map.put(rs.getString("domain_id"), faqList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadNews(Db db, Map<String, List<News>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT parent_id, store_id, language_id, title, description, thumb_image FROM vc_news WHERE publish = 1 AND news_type = 1 ORDER BY store_id, created_at DESC LIMIT 18";
            rs = db.select().resultSet(query, (Object[])null);
            Map dupe = new HashMap();
            List<News> newsList = null;
            String prev = null;

            while(rs.next()) {
                News nw = new News();
                nw.setStoreId(rs.getString("store_id"));
                if (dupe.get(nw.getStoreId()) == null) {
                    if (prev != null) {
                        map.put(prev, newsList);
                    }

                    newsList = new ArrayList();
                    prev = nw.getStoreId();
                    dupe.put(nw.getStoreId(), "1");
                }

                nw.setParentId(rs.getString("parent_id"));
                nw.setLanguageId(rs.getString("language_id"));
                nw.setTitle(rs.getString("title"));
                nw.setDescription(rs.getString("description"));
                nw.setImage(rs.getString("thumb_image"));
                newsList.add(nw);
                map.put(rs.getString("store_id"), newsList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadArticles(Db db, Map<String, List<Articles>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT parent_id, store_id, language_id, title, description, thumb_image FROM vc_news WHERE publish = 1 AND news_type = 2 ORDER BY store_id, created_at DESC LIMIT 18";
            rs = db.select().resultSet(query, (Object[])null);
            Map dupe = new HashMap();
            List<Articles> articleList = null;
            String prev = null;

            while(rs.next()) {
                Articles ar = new Articles();
                ar.setStoreId(rs.getString("store_id"));
                if (dupe.get(ar.getStoreId()) == null) {
                    if (prev != null) {
                        map.put(prev, articleList);
                    }

                    articleList = new ArrayList();
                    prev = ar.getStoreId();
                    dupe.put(ar.getStoreId(), "1");
                }

                ar.setParentId(rs.getString("parent_id"));
                ar.setLanguageId(rs.getString("language_id"));
                ar.setTitle(rs.getString("title"));
                ar.setDescription(rs.getString("description"));
                ar.setImage(rs.getString("thumb_image"));
                articleList.add(ar);
                map.put(rs.getString("store_id"), articleList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static String loadSeoUrlActive(Db db, String pageType, String pageTypeFk, String languageId, String domainId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        Object var9;
        try {
            String query = "SELECT TD.domain_id,TD.seo_url,TD.page_type,TD.language_id,TD.page_title,TD.meta_description,TD.meta_keywords,TD.pagetype_fk,TD.archieved FROM vc_domain_seo_config TD WHERE TD.page_type = ? AND TD.pagetype_fk = ? AND TD.archieved = ? AND TD.language_id = ? AND TD.domain_id = ? ORDER BY TD.domain_id,TD.page_type";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setInt(1, Integer.parseInt(pageType));
            psSeo.setInt(2, Integer.parseInt(pageTypeFk));
            psSeo.setInt(3, 0);
            psSeo.setInt(4, Integer.parseInt(languageId));
            psSeo.setInt(5, Integer.parseInt(domainId));
            rs = psSeo.executeQuery();
            if (rs.next()) {
                String var8 = rs.getString("seo_url");
                return var8;
            }

            var9 = null;
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return (String)var9;
    }

    public static String loadZipFileCampaign(Db db, String campId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psCamp = null;

        String var6;
        try {
            String query = "SELECT zip_file FROM vc_campaign WHERE id = ?";
            psCamp = db.select().getPreparedStatement(query);
            psCamp.clearParameters();
            psCamp.setInt(1, Integer.parseInt(campId));
            rs = psCamp.executeQuery();
            if (!rs.next()) {
                return null;
            }

            String var5 = rs.getString("zip_file").replaceAll(".zip", "");
            var6 = var5;
        } finally {
            Cleaner.close(psCamp);
            Cleaner.close(rs);
            db.select().clean();
        }

        return var6;
    }

    public static void loadHead(Db db, Map<String, List<Heading>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT language_id, domain_id, heading, sub_heading FROM vc_heading WHERE publish = 1 ORDER BY domain_id";
            rs = db.select().resultSet(query, (Object[])null);
            List<Heading> headList = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Heading head = new Heading();
                head.setDomainId(rs.getString("domain_id"));
                if (dupe.get(head.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, headList);
                    }

                    headList = new ArrayList();
                    prev = head.getDomainId();
                    dupe.put(head.getDomainId(), "1");
                }

                head.setLanguageId(rs.getString("language_id"));
                head.setHeading(rs.getString("heading"));
                head.setSubHeading(rs.getString("sub_heading"));
                headList.add(head);
                map.put(rs.getString("domain_id"), headList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadCancelOrders(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT domain_id,description from vc_howtouse where type = 2";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("domain_id"), rs.getString("description"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static String loadcategoryUrl(Db db, String catId, String domainId, String languageId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        try {
            String query = "SELECT seo_url FROM vc_domain_seo_config WHERE pagetype_fk = ? AND domain_id = ? AND language_id = ? AND page_type = 4";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setInt(1, Integer.parseInt(catId));
            psSeo.setInt(2, Integer.parseInt(domainId));
            psSeo.setInt(3, Integer.parseInt(languageId));
            rs = psSeo.executeQuery();
            if (rs.next()) {
                String var7 = rs.getString("seo_url");
                String var8 = var7;
                return var8;
            }
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return null;
    }

    public static String loadcategoryId(Db db, String name, String languageId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        Object var7;
        try {
            String query = "SELECT parent_id FROM gl_category WHERE LOWER(name) = ? AND language_id = ?";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setString(1, name.toLowerCase());
            psSeo.setInt(2, Integer.parseInt(languageId));
            rs = psSeo.executeQuery();
            if (rs.next()) {
                String var6 = rs.getString("parent_id");
                return var6;
            }

            var7 = null;
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return (String)var7;
    }

    public static void loadSpecials(Db db, Map<String, List<Specials>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TS.id,TSC.id AS bcid,TS.parent_id,TS.language_id,TS.name,TS.image,TSC.domain_id,TSEO.seo_url FROM gl_special TS, bg_special_domain TSC,vc_domain_seo_config TSEO WHERE TS.publish = 1 AND TSC.publish = 1 AND TS.parent_id = TSC.special_id AND TSC.special_id = TSEO.pagetype_fk AND TSC.domain_id = TSEO.domain_id AND TSEO.language_id = TS.language_id AND TSEO.page_type = 60 AND TSEO.archieved = 0 ORDER BY TSC.domain_id,TS.name";
            rs = db.select().resultSet(query, (Object[])null);
            List<Specials> specialListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Specials sp = new Specials();
                sp.setId(rs.getString("parent_id"));
                sp.setDomainId(rs.getString("domain_id"));
                if (dupe.get(sp.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, specialListDomain);
                    }

                    specialListDomain = new ArrayList();
                    prev = sp.getDomainId();
                    dupe.put(sp.getDomainId(), "1");
                }

                sp.setBsid(rs.getString("bcid"));
                sp.setName(rs.getString("name"));
                sp.setImage(rs.getString("image"));
                sp.setLanguageId(rs.getString("language_id"));
                sp.setSeoUrl(rs.getString("seo_url"));
                specialListDomain.add(sp);
                map.put(rs.getString("domain_id"), specialListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadSpecialOffers(Db db, Map<String, Map<String, List<VoucherDeals>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id, TOF.benefit_type, TOF.benefit_value,TST.domain_id,TOFL.language_id,BOS.special_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,bg_offer_special BOS,vc_store_lang TSL,vc_domain_seo_config TSEO,vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND BOS.offer_id = TOF.id AND TOFL.language_id = TSL.language_id AND TST.PUBLISH = 1 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,BOS.special_id DESC,TOFL.modified_at DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            new HashMap();
            new HashMap();
            Map<String, List<VoucherDeals>> m = null;
            String prev = null;

            for(String prev1 = null; rs.next(); prev1 = rs.getString("special_id")) {
                VoucherDeals vd = new VoucherDeals();
                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setSpecialId(rs.getString("special_id"));
                if (!rs.getString("domain_id").equals(prev)) {
                    m = new HashMap();
                    offerListDomain = new ArrayList();
                }

                if (!rs.getString("special_id").equals(prev1)) {
                    offerListDomain = new ArrayList();
                }

                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreId(rs.getString("store_id"));
                vd.setBenifitType(rs.getString("benefit_type"));
                vd.setBenifitValue(rs.getString("benefit_value"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }

                offerListDomain.add(vd);
                m.put(rs.getString("special_id"), offerListDomain);
                map.put(rs.getString("domain_id"), m);
                prev = rs.getString("domain_id");
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static String loadCategoryName(Db db, String domainId, String seo, String languageId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        String var8;
        try {
            String query = "SELECT gc.name FROM gl_category gc, vc_domain_seo_config vdsc WHERE gc.parent_id = vdsc.pagetype_fk AND vdsc.seo_url = ? AND vdsc.domain_id = ?  AND gc.language_id = ? AND gc.language_id = vdsc.language_id";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setString(1, seo);
            psSeo.setInt(2, Integer.parseInt(domainId));
            psSeo.setInt(3, Integer.parseInt(languageId));
            rs = psSeo.executeQuery();
            if (!rs.next()) {
                return null;
            }

            String var7 = rs.getString("name");
            var8 = var7;
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return var8;
    }

    public static String loadStoreName(Db db, String domainId, String seo) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        Object var7;
        try {
            String query = "SELECT vsl.name FROM vc_store_lang vsl, vc_domain_seo_config vdsc WHERE vsl.store_id = vdsc.pagetype_fk and vdsc.seo_url = ? AND vdsc.domain_id = ? ";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setString(1, seo);
            psSeo.setInt(2, Integer.parseInt(domainId));
            rs = psSeo.executeQuery();
            if (rs.next()) {
                String var6 = rs.getString("name");
                return var6;
            }

            var7 = null;
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return (String)var7;
    }

    public static String loadSpecialName(Db db, String domainId, String seo) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        String var7;
        try {
            String query = "SELECT gs.name FROM gl_special gs, vc_domain_seo_config vdsc WHERE gs.id = vdsc.pagetype_fk AND vdsc.seo_url = ? AND vdsc.domain_id = ? ";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setString(1, seo);
            psSeo.setInt(2, Integer.parseInt(domainId));
            rs = psSeo.executeQuery();
            if (!rs.next()) {
                return null;
            }

            String var6 = rs.getString("name");
            var7 = var6;
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return var7;
    }

    public static String loadStoreCatNameTopMenu(Db db, String domainId, String seo, String languageId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        String var7;
        try {
            String query = "SELECT VSL.name AS storename, VSL.seo_url, GC.name AS catname FROM vc_domain_seo_config VDSC, bg_store_category BSC, vc_store_lang VSL, gl_category GC WHERE VDSC.pagetype_fk = BSC.id AND VSL.store_id = BSC.store_id AND GC.parent_id = BSC.category_id AND VDSC.seo_url = ? AND VDSC.domain_id = ? AND GC.language_id = ? AND GC.language_id = VDSC.language_id";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setString(1, seo);
            psSeo.setInt(2, Integer.parseInt(domainId));
            psSeo.setInt(3, Integer.parseInt(languageId));
            rs = psSeo.executeQuery();
            if (!rs.next()) {
                Object var8 = null;
                return (String)var8;
            }

            String var10000 = rs.getString("storename");
            var7 = var10000 + "###" + rs.getString("seo_url") + "###" + rs.getString("catname");
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return var7;
    }

    public static void logUser(Db db, String userInfo) throws SQLException {
        db.execute().ddl(userInfo);
    }

    public static String loadStoreBrandName(Db db, String domainId, String seo, String languageId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        String var7;
        try {
            String query = "SELECT VSL.name AS storename, VSL.seo_url, GB.name AS brandname FROM vc_domain_seo_config VDSC, bg_brand_store BBS, vc_store_lang VSL, gl_brand GB WHERE VDSC.pagetype_fk = BBS.id AND VSL.store_id = BBS.store_id AND GB.parent_id = BBS.brand_id AND VDSC.seo_url = ? AND VDSC.domain_id = ? AND GB.language_id = ? AND GB.language_id = VDSC.language_id";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setString(1, seo);
            psSeo.setInt(2, Integer.parseInt(domainId));
            psSeo.setInt(3, Integer.parseInt(languageId));
            rs = psSeo.executeQuery();
            if (!rs.next()) {
                Object var8 = null;
                return (String)var8;
            }

            String var10000 = rs.getString("storename");
            var7 = var10000 + "###" + rs.getString("seo_url") + "###" + rs.getString("brandname");
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return var7;
    }

    public static String loadStoreCouponName(Db db, String domainId, String couponId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;
        String offerType = "";

        Object var8;
        try {
            String query = "SELECT vo.offer_type, vo.offer_subtype, vsl.name AS storename, vsl.seo_url  FROM vc_offer vo, vc_store_lang vsl WHERE vo.store_id = vsl.store_id AND vo.id = ? AND vo.domain_id = ?";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setInt(1, Integer.parseInt(couponId));
            psSeo.setInt(2, Integer.parseInt(domainId));
            rs = psSeo.executeQuery();
            if (rs.next()) {
                if (rs.getInt("offer_type") == 1) {
                    offerType = "Coupon";
                } else if (rs.getInt("offer_type") == 2 && rs.getInt("offer_subtype") == 4) {
                    offerType = "Offer";
                } else if (rs.getInt("offer_type") == 2 && rs.getInt("offer_subtype") == 5) {
                    offerType = "Deal";
                } else if (rs.getInt("offer_type") == 2 && rs.getInt("offer_subtype") == 6) {
                    offerType = "Sale";
                }

                String var10000 = rs.getString("storename");
                String var7 = var10000 + "###" + rs.getString("seo_url") + "###" + offerType;
                return var7;
            }

            var8 = null;
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return (String)var8;
    }

    public static void loadMetaData(Db db, Map<String, List<MetaTags>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT id,domain_id,meta_data FROM vc_meta_data ORDER BY domain_id,priority";
            rs = db.select().resultSet(query, (Object[])null);
            Map dupe = new HashMap();
            List<MetaTags> metaList = null;
            String prev = null;

            while(rs.next()) {
                MetaTags m = new MetaTags();
                m.setId(rs.getString("id"));
                m.setDomainId(rs.getString("domain_id"));
                if (dupe.get(m.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, metaList);
                    }

                    metaList = new ArrayList();
                    prev = m.getDomainId();
                    dupe.put(m.getDomainId(), "1");
                }

                m.setMetaTags(rs.getString("meta_data"));
                metaList.add(m);
                map.put(prev, metaList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadCatSpecials(Db db, Map<String, Map<String, List<Specials>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT bdsc.special_id, vs.image, vsl.name, vdsc.page_title, vdsc.meta_keywords, vdsc.meta_description, vsl.description, vdsc.seo_url, bdsc.category_id, vsl.language_id, bdsc.domain_id FROM bg_domain_special_category bdsc, vc_special vs, vc_special_lang vsl, vc_domain_seo_config vdsc WHERE vs.id = bdsc.special_id AND vdsc.page_type = 60 AND vs.domain_id = bdsc.domain_id AND vs.publish = 1 AND vsl.special_id = vs.id AND vdsc.domain_id = vs.domain_id AND vdsc.language_id = vsl.language_id AND vdsc.pagetype_fk = vs.id  AND vdsc.archieved = 0 ORDER BY bdsc.domain_id, bdsc.category_id, vs.priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<Specials> specialListDomain = null;
            Map<String, List<Specials>> m = null;
            String prev = null;

            for(String prev1 = null; rs.next(); prev1 = rs.getString("category_id")) {
                Specials sp = new Specials();
                sp.setId(rs.getString("special_id"));
                sp.setDomainId(rs.getString("domain_id"));
                sp.setCategoryId(rs.getString("category_id"));
                if (!rs.getString("domain_id").equals(prev)) {
                    m = new HashMap();
                    specialListDomain = new ArrayList();
                }

                if (!rs.getString("category_id").equals(prev1)) {
                    specialListDomain = new ArrayList();
                }

                sp.setImage(rs.getString("image"));
                sp.setDesc(rs.getString("description"));
                sp.setLanguageId(rs.getString("language_id"));
                sp.setMetaDesc(rs.getString("meta_description"));
                sp.setMetaKeywords(rs.getString("meta_keywords"));
                sp.setPageTitle(rs.getString("page_title"));
                sp.setName(rs.getString("name"));
                sp.setSeoUrl(rs.getString("seo_url"));
                specialListDomain.add(sp);
                m.put(rs.getString("category_id"), specialListDomain);
                map.put(rs.getString("domain_id"), m);
                prev = rs.getString("domain_id");
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static String loadSpecialCatName(Db db, String catId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        try {
            String query = "SELECT name FROM gl_category WHERE id = ?";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setInt(1, Integer.parseInt(catId));
            rs = psSeo.executeQuery();
            if (rs.next()) {
                String var5 = rs.getString("name");
                String var6 = var5;
                return var6;
            }
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return null;
    }

    public static String loadSpecialDet(Db db, String specialId) throws SQLException {
        ResultSet rs = null;
        PreparedStatement psSeo = null;

        String var5;
        try {
            String query = "SELECT name,description FROM vc_special_lang WHERE special_id = ?";
            psSeo = db.select().getPreparedStatement(query);
            psSeo.clearParameters();
            psSeo.setInt(1, Integer.parseInt(specialId));
            rs = psSeo.executeQuery();
            if (!rs.next()) {
                Object var6 = null;
                return (String)var6;
            }

            String var10000 = rs.getString("name");
            var5 = var10000 + "###" + rs.getString("description");
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            db.select().clean();
        }

        return var5;
    }

    public static List<Specials> loadSimilarCatSpecials(Db db, String domainId, String langId, String spId) throws SQLException {
        ResultSet rs = null;
        ResultSet rsCat = null;
        List<Specials> specialListDomain = new ArrayList();
        PreparedStatement psSeo = null;
        PreparedStatement psCat = null;
        String specialIdList = "0";

        try {
            String qryCat = "SELECT category_id FROM bg_domain_special_category WHERE special_id = ? AND domain_id = ?";
            psCat = db.select().getPreparedStatement(qryCat);
            psCat.clearParameters();
            psCat.setInt(1, Integer.parseInt(spId));
            psCat.setInt(2, Integer.parseInt(domainId));
            rsCat = psCat.executeQuery();

            while(rsCat.next()) {
                String query = "SELECT bdsc.special_id, vs.image, vsl.name, vdsc.page_title, vdsc.meta_keywords, vdsc.meta_description, vsl.description, vdsc.seo_url, bdsc.category_id, vsl.language_id, bdsc.domain_id FROM bg_domain_special_category bdsc, vc_special vs, vc_special_lang vsl, vc_domain_seo_config vdsc WHERE vs.id = bdsc.special_id AND vdsc.page_type = ? AND vs.domain_id = bdsc.domain_id AND vs.publish = 1 AND vsl.special_id = vs.id AND vdsc.domain_id = vs.domain_id AND vdsc.language_id = vsl.language_id AND vdsc.pagetype_fk = vs.id AND vdsc.archieved = 0 AND vdsc.language_id = ? AND vdsc.domain_id = ? AND bdsc.special_id <> ? AND bdsc.category_id = ? AND bdsc.special_id::text NOT IN (SELECT unnest(string_to_array(?, ','))) ORDER BY bdsc.domain_id, bdsc.category_id, vs.priority";
                psSeo = db.select().getPreparedStatement(query);
                psSeo.clearParameters();
                psSeo.setInt(1, Integer.parseInt("60"));
                psSeo.setInt(2, Integer.parseInt(langId));
                psSeo.setInt(3, Integer.parseInt(domainId));
                psSeo.setInt(4, Integer.parseInt(spId));
                psSeo.setInt(5, rsCat.getInt("category_id"));
                psSeo.setString(6, specialIdList);

                for(rs = psSeo.executeQuery(); rs.next(); specialIdList = specialIdList + "," + rs.getString("special_id")) {
                    Specials sp = new Specials();
                    sp.setId(rs.getString("special_id"));
                    sp.setDomainId(rs.getString("domain_id"));
                    sp.setCategoryId(rs.getString("category_id"));
                    sp.setImage(rs.getString("image"));
                    sp.setDesc(rs.getString("description"));
                    sp.setLanguageId(rs.getString("language_id"));
                    sp.setMetaDesc(rs.getString("meta_description"));
                    sp.setMetaKeywords(rs.getString("meta_keywords"));
                    sp.setPageTitle(rs.getString("page_title"));
                    sp.setName(rs.getString("name"));
                    sp.setSeoUrl(rs.getString("seo_url"));
                    specialListDomain.add(sp);
                }
            }
        } finally {
            Cleaner.close(psSeo);
            Cleaner.close(rs);
            Cleaner.close(psCat);
            Cleaner.close(rsCat);
            db.select().clean();
        }

        return specialListDomain;
    }

    public static void loadOfferCountStore(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT COUNT(VO.id), VO.store_id,VO.domain_id FROM vc_offer VO,vc_domain_date  TD WHERE VO.domain_id = TD.D_Id AND VO.start_date <= TD.Curr_Date AND VO.end_date >= TD.Curr_Date AND VO.publish = 1 GROUP BY VO.domain_id,VO.store_id ORDER BY VO.domain_id,VO.store_id";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("store_id"), rs.getString("count"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadOfferCountStoreDesktop(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT COUNT(VO.id), VO.store_id,VO.domain_id FROM vc_offer VO,vc_domain_date  TD WHERE VO.domain_id = TD.D_Id AND VO.start_date <= TD.Curr_Date AND VO.end_date >= TD.Curr_Date AND VO.publish = 1 AND VIEW_TYPE = 0 GROUP BY VO.domain_id,VO.store_id ORDER BY VO.domain_id,VO.store_id";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("store_id"), rs.getString("count"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static List<VoucherDeals> loadSimilarStoreOffer(Db db, String storeId, String languageId, String catId) throws SQLException {
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
        PreparedStatement psStore = null;
        List<VoucherDeals> storeListId = new ArrayList();
        HashMap mapDupStore = new HashMap();

        try {
            String query = "SELECT DISTINCT ON(store_id) TOF.store_id,  TOF.used_count AS used_count_today,TOF.id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TOF.benefit_type,TOF.benefit_value,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL,vc_store TST, vc_store_lang TSL,vc_domain_seo_config TSEO,bg_offer_category TSC WHERE TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= current_date AND TOF.end_date >= current_date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TST.publish = 1 AND TSEO.pagetype_fk = TST.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 AND TST.id::text IN(SELECT unnest(string_to_array(?, ',')))  AND TSL.language_id = ? AND TSC.offer_id = TOF.id AND TSC.category_id::TEXT IN(SELECT unnest(string_to_array(?, ','))) ORDER BY store_id, TOF.used_count DESC";
            psStore = db.select().getPreparedStatement(query);
            psStore.clearParameters();
            psStore.setString(1, storeId);
            psStore.setInt(2, Integer.parseInt(languageId));
            psStore.setString(3, catId);
            rs = psStore.executeQuery();
            ArrayList v = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id")) == null) {
                    v = new ArrayList();
                }

                v.add("1");
                mapDupStore.put(rs.getString("store_id") + rs.getString("language_id"), v);
                var10001 = rs.getString("store_id");
                if (((List)mapDupStore.get(var10001 + rs.getString("language_id"))).size() <= 2) {
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setBenifitType(rs.getString("benefit_type"));
                    vd.setBenifitValue(rs.getString("benefit_value"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    storeListId.add(vd);
                }
            }
        } finally {
            Cleaner.close(psStore);
            Cleaner.close(rs);
            db.select().clean();
        }

        return storeListId;
    }

    public static void loadAllSpecialsCat(Db db, Map<String, List<Specials>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT DISTINCT bdsc.domain_id, vdsc.language_id, bdsc.category_id, gc.name AS catname, vdsc.seo_url FROM bg_domain_special_category bdsc, gl_category gc, vc_domain_seo_config vdsc, vc_special vs WHERE bdsc.category_id = gc.id AND gc.publish = 1 AND vdsc.domain_id = bdsc.domain_id AND vdsc.pagetype_fk = bdsc.category_id AND vdsc.page_type = 70 AND vdsc.archieved = 0 AND vdsc.publish = 1 AND bdsc.special_id = vs.id AND vs.publish = 1 ORDER BY bdsc.domain_id, vdsc.language_id, bdsc.category_id";
            rs = db.select().resultSet(query, (Object[])null);
            List<Specials> specialListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Specials sp = new Specials();
                sp.setDomainId(rs.getString("domain_id"));
                if (dupe.get(sp.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, specialListDomain);
                    }

                    specialListDomain = new ArrayList();
                    prev = sp.getDomainId();
                    dupe.put(sp.getDomainId(), "1");
                }

                sp.setCategoryId(rs.getString("category_id"));
                sp.setName(rs.getString("catname"));
                sp.setLanguageId(rs.getString("language_id"));
                sp.setSeoUrl(rs.getString("seo_url"));
                specialListDomain.add(sp);
                map.put(rs.getString("domain_id"), specialListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadAllSpecials(Db db, Map<String, List<Specials>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT vs.domain_id, vsl.language_id, bdsc.category_id, vs.top_view, vs.image_url, vsl.heading,vsl.special_id, vsl.name AS specialname, vdsc.seo_url AS specseo, vs.image FROM vc_special_lang vsl, vc_special vs, bg_domain_special_category bdsc, gl_category gc, vc_domain_seo_config vdsc WHERE vs.id = vsl.special_id AND vs.publish = 1 AND bdsc.special_id = vs.id AND bdsc.domain_id = vs.domain_id AND gc.id = bdsc.category_id  AND gc.publish = 1 AND vdsc.domain_id = bdsc.domain_id AND vdsc.language_id = vsl.language_id AND vdsc.page_type = 60 AND vdsc.pagetype_fk = vs.id AND vdsc.archieved = 0 AND vdsc.publish = 1 ORDER BY vs.domain_id, vsl.language_id, bdsc.category_id, vs.id";
            rs = db.select().resultSet(query, (Object[])null);
            List<Specials> specialListDomain = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Specials sp = new Specials();
                sp.setDomainId(rs.getString("domain_id"));
                if (dupe.get(sp.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, specialListDomain);
                    }

                    specialListDomain = new ArrayList();
                    prev = sp.getDomainId();
                    dupe.put(sp.getDomainId(), "1");
                }

                sp.setCategoryId(rs.getString("category_id"));
                sp.setId(rs.getString("special_id"));
                sp.setLanguageId(rs.getString("language_id"));
                sp.setName(rs.getString("specialname"));
                sp.setSeoUrl(rs.getString("specseo"));
                sp.setTopView(rs.getString("top_View"));
                sp.setImage(rs.getString("image"));
                sp.setImageUrl(rs.getString("image_url"));
                sp.setHeading(rs.getString("heading"));
                specialListDomain.add(sp);
                map.put(rs.getString("domain_id"), specialListDomain);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadTotalPopularStores(Db db, Map<String, Integer> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT domain_id,COUNT(*) AS totalCount FROM vc_store WHERE popular_store = 1 GROUP BY domain_id ORDER BY domain_id";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("domain_id"), rs.getInt("totalCount"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadDomainsCountry(Db db, Map<String, List<Domains>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TD.id,TD.domain_group_id,TD.theme_id,TD.name,TD.image,TD.domain_url,TD.fb_url,TD.twit_url,TD.pn_url,TD.gplus_url ,TD.analytics_code,TD.certificate ,TD.test_certificate,TD.currency_type,TD.logo,logo_small,TC.name AS country_name FROM vc_domain TD, gl_country TC WHERE TD.publish = 1 AND TC.id = TD.country_id AND TC.publish = 1 ORDER BY TC.name ASC";
            rs = db.select().resultSet(query, (Object[])null);
            List<Domains> groupList = null;
            groupList = new ArrayList();

            while(rs.next()) {
                Domains dm = new Domains();
                dm.setId(rs.getString("id"));
                dm.setDomainGroupId(rs.getString("domain_group_id"));
                dm.setThemeId(rs.getString("theme_id"));
                dm.setName(rs.getString("name"));
                dm.setImage(rs.getString("image"));
                dm.setDomainUrl(rs.getString("domain_url"));
                dm.setFbLink(rs.getString("fb_url"));
                dm.setGpLink(rs.getString("gplus_url"));
                dm.setTwLink(rs.getString("twit_url"));
                dm.setPnLink(rs.getString("pn_url"));
                dm.setAnalyticsCode(rs.getString("analytics_code"));
                dm.setGuaranteeCertificate(rs.getString("certificate"));
                dm.setTestGuarantee(rs.getString("test_certificate"));
                dm.setCurrencyType(rs.getString("currency_type"));
                dm.setLogo(rs.getString("logo"));
                dm.setLogoMobile(rs.getString("logo_small"));
                dm.setCountryName(rs.getString("country_name"));
                groupList.add(dm);
            }

            map.put("1", groupList);
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }
    }

    public static void loadDomainGroup(Db db, Map<String, List<DomainGroup>> map) throws SQLException {
        map.clear();
        ResultSet rsDomainGroup = null;

        try {
            DomainGroup domainGroup = null;
            List<DomainGroup> listDomainGroup = new ArrayList();
            String query = "SELECT id,name,code FROM gl_domain_group WHERE publish = 1 ORDER BY name";
            rsDomainGroup = db.select().resultSet(query, (Object[])null);

            while(rsDomainGroup.next()) {
                domainGroup = new DomainGroup();
                domainGroup.setId(rsDomainGroup.getString("id"));
                domainGroup.setName(rsDomainGroup.getString("name"));
                domainGroup.setCode(rsDomainGroup.getString("code"));
                listDomainGroup.add(domainGroup);
            }

            map.put("1", listDomainGroup);
        } finally {
            Cleaner.close(rsDomainGroup);
            db.select().clean();
        }
    }

    public static List<GlCountry> loadDomainCountry(Db db, Map<String, List<GlCountry>> map) throws SQLException {
        ResultSet rsCountry = null;
        map.clear();
        GlCountry glCountry = null;
        ArrayList listDomainGroup = new ArrayList();

        try {
            String query = "SELECT GC.id AS countryId, VD.id AS domainId, GDG.id AS domain_group_id, GC.name AS country_name, GC.code, VD.image, VD.domain_url FROM gl_country GC, gl_domain_group GDG, vc_domain VD WHERE GC.publish = 1 AND VD.domain_group_id = GDG.id AND VD.country_id = GC.id AND VD.publish = 1 ORDER BY GDG.id, GC.name";
            rsCountry = db.select().resultSet(query, (Object[])null);
            Map dupe = new HashMap();
            String prev = null;

            while(rsCountry.next()) {
                glCountry = new GlCountry();
                glCountry.setDomainGroupId(rsCountry.getString("domain_group_id"));
                if (dupe.get(glCountry.getDomainGroupId()) == null) {
                    if (prev != null) {
                        map.put(prev, listDomainGroup);
                    }

                    listDomainGroup = new ArrayList();
                    prev = glCountry.getDomainGroupId();
                    dupe.put(glCountry.getDomainGroupId(), "1");
                }

                glCountry.setId(rsCountry.getString("countryId"));
                glCountry.setDomainId(rsCountry.getString("domainId"));
                glCountry.setName(rsCountry.getString("country_name"));
                glCountry.setCode(rsCountry.getString("code"));
                glCountry.setFlag(rsCountry.getString("image"));
                glCountry.setDomainUrl(rsCountry.getString("domain_url"));
                listDomainGroup.add(glCountry);
                map.put(rsCountry.getString("domain_group_id"), listDomainGroup);
            }
        } finally {
            Cleaner.close(rsCountry);
            db.select().clean();
        }

        return listDomainGroup;
    }

    public static void loadTop20OffersMobile(Db db, Map<String, List<VoucherDeals>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,vc_store_lang TSL,vc_domain_seo_config TSEO, vc_domain_date  TD WHERE TOF.domain_id = TD.D_Id AND TST.publish = 1 AND TST.popular_store = 1 AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOFL.language_id = TSL.language_id AND TOF.offer_type = 2 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 AND TST.popular_store_priority <= 25 ORDER BY TST.domain_id DESC,TOF.used_count DESC,TOF.id DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            Map<String, String> mapDupStore = new HashMap();
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                String var10001 = rs.getString("store_id");
                if (mapDupStore.get(var10001 + rs.getString("language_id")) == null) {
                    mapDupStore.put(rs.getString("store_id") + rs.getString("language_id"), "value");
                    VoucherDeals vd = new VoucherDeals();
                    vd.setId(rs.getString("id"));
                    vd.setDomainId(rs.getString("domain_id"));
                    if (dupe.get(vd.getDomainId()) == null) {
                        if (prev != null) {
                            map.put(prev, offerListDomain);
                        }

                        offerListDomain = new ArrayList();
                        prev = vd.getDomainId();
                        dupe.put(vd.getDomainId(), "1");
                    }

                    vd.setCouponCode(rs.getString("coupon_code"));
                    vd.setEndDate(sdf.format(rs.getDate("end_date")));
                    vd.setImageBig(rs.getString("image_big"));
                    vd.setImageSmall(rs.getString("image_small"));
                    vd.setLanguageId(rs.getString("language_id"));
                    vd.setOfferDislike(rs.getString("offer_dislike"));
                    vd.setOfferLike(rs.getString("offer_like"));
                    vd.setOfferType(rs.getString("offer_type"));
                    vd.setOfferUrl(rs.getString("offer_url"));
                    vd.setStoreId(rs.getString("store_id"));
                    vd.setStoreUrl(rs.getString("affiliate_url"));
                    vd.setOfferHeading(rs.getString("offer_heading"));
                    vd.setOfferDesc(rs.getString("offer_description"));
                    vd.setStoreName(rs.getString("name"));
                    vd.setStoreSeoUrl(rs.getString("seo_url"));
                    vd.setOfferImage(rs.getString("image"));
                    vd.setUsedCountToday(rs.getString("used_count_today"));
                    vd.setViewType(rs.getString("view_type"));
                    vd.setExclusive(rs.getString("exclusive_coupon"));
                    if (rs.getDate("modified_at") != null) {
                        vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                    }

                    offerListDomain.add(vd);
                    map.put(rs.getString("domain_id"), offerListDomain);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadAllStoresByNameMobile(Db db, Map<String, List<AllStoresMobile>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT COALESCE(TUCNT.offer_count,0) AS offer_count, TS.id,TS.domain_id,TSL.language_id,TSL.name,TSL.seo_url AS seo_url11,'http://'||TD.domain_url||'/' AS page_url,TSEO.seo_url,TS.image_small FROM vc_store TS LEFT OUTER JOIN(SELECT COUNT(VO.id) AS offer_count, VO.store_id AS st_id,VO.domain_id FROM vc_offer VO,vc_domain_date  TD WHERE VO.domain_id = TD.D_Id AND VO.start_date <= TD.Curr_Date AND VO.end_date >= TD.Curr_Date AND VO.publish = 1 GROUP BY VO.domain_id,VO.store_id ORDER BY VO.domain_id,VO.store_id )AS TUCNT ON TUCNT.st_id = TS.id,vc_store_lang TSL,vc_domain TD,vc_domain_seo_config TSEO WHERE TS.trash = 0 AND TS.publish = 1 AND TS.id = TSL.store_id AND TD.id = TS.domain_id AND TSEO.pagetype_fk = TS.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TS.domain_id,TSL.language_id,TSL.name";
            rs = db.select().resultSet(query, (Object[])null);
            List<AllStoresMobile> allStoreList = null;
            AllStoresMobile store = null;
            Map dupeDomain = new HashMap();
            String prevDomain = null;
            Map dupeAbc = new HashMap();
            String prevAbc = null;
            String domainId = null;
            String key = null;

            while(true) {
                if (!rs.next()) {
                    if (domainId != null) {
                        allStoreList.add(store);
                        map.put(prevDomain, allStoreList);
                    }
                    break;
                }

                domainId = rs.getString("domain_id");
                key = domainId + rs.getString("language_id");
                if (dupeDomain.get(key) == null) {
                    if (prevAbc != null) {
                        allStoreList.add(store);
                        prevAbc = null;
                    }

                    if (prevDomain != null) {
                        map.put(prevDomain, allStoreList);
                    }

                    allStoreList = new ArrayList();
                    prevDomain = key;
                    dupeDomain.put(key, "1");
                }

                String name = rs.getString("name");
                String alphabet = name.substring(0, 1);
                if (alphabet.matches("-?\\d+(\\.\\d+)?")) {
                    alphabet = "0-9";
                }

                if (dupeAbc.get((alphabet + key).toLowerCase()) == null) {
                    if (prevAbc != null) {
                        allStoreList.add(store);
                    }

                    prevAbc = alphabet;
                    dupeAbc.put((alphabet + key).toLowerCase(), "1");
                    store = new AllStoresMobile(alphabet);
                }

                store.addContent(rs.getString("page_url") + rs.getString("seo_url"), name, rs.getString("image_small"), rs.getString("offer_count"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadCategoryOffersMobile(Db db, Map<String, Map<String, List<VoucherDeals>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

        try {
            String query = "SELECT TOF.used_count AS used_count_today,TOF.id,TOF.store_id,TST.domain_id,TOFL.language_id,TOB.category_id,TOF.coupon_code,TOF.offer_url,TOF.start_date,TOF.end_date,TOF.offer_like,TOF.offer_dislike,TOF.view_type, TOF.exclusive_coupon,TST.image_small,TST.image_big,TST.affiliate_url,TOFL.offer_heading,TOFL.offer_description,TOF.offer_type,TOF.used_count,TSL.name,TSL.seo_url AS seo_url11,TOF.image,TOFL.modified_at,TSEO.seo_url FROM vc_offer TOF, vc_offer_lang TOFL, vc_store TST,bg_offer_category TOB,vc_store_lang TSL,vc_domain_seo_config TSEO ,vc_domain_date TD WHERE TOF.domain_id = TD.D_Id AND TOF.store_id = TST.id AND TOF.id = TOFL.offer_id AND TOF.start_date <= TD.Curr_Date AND TOF.end_date >= TD.Curr_Date AND TSL.store_id = TST.id AND TOF.publish = 1 AND TOF.trash = 0 AND TST.trash = 0 AND TOB.offer_id = TOF.id AND TOFL.language_id = TSL.language_id AND TST.PUBLISH = 1 AND TSEO.pagetype_fk = TST.id AND page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TST.domain_id DESC,TOB.category_id DESC,TOFL.modified_at DESC";
            rs = db.select().resultSet(query, (Object[])null);
            List<VoucherDeals> offerListDomain = null;
            new HashMap();
            new HashMap();
            new HashMap();
            Map<String, List<VoucherDeals>> m = null;
            String prev = null;

            for(String prev1 = null; rs.next(); prev1 = rs.getString("category_id")) {
                VoucherDeals vd = new VoucherDeals();
                vd.setId(rs.getString("id"));
                vd.setDomainId(rs.getString("domain_id"));
                vd.setCategoryId(rs.getString("category_id"));
                if (!rs.getString("domain_id").equals(prev)) {
                    m = new HashMap();
                    offerListDomain = new ArrayList();
                }

                if (!rs.getString("category_id").equals(prev1)) {
                    offerListDomain = new ArrayList();
                }

                vd.setCouponCode(rs.getString("coupon_code"));
                vd.setEndDate(sdf.format(rs.getDate("end_date")));
                vd.setImageBig(rs.getString("image_big"));
                vd.setImageSmall(rs.getString("image_small"));
                vd.setLanguageId(rs.getString("language_id"));
                vd.setOfferDislike(rs.getString("offer_dislike"));
                vd.setOfferLike(rs.getString("offer_like"));
                vd.setOfferType(rs.getString("offer_type"));
                vd.setOfferUrl(rs.getString("offer_url"));
                vd.setStoreId(rs.getString("store_id"));
                vd.setStoreUrl(rs.getString("affiliate_url"));
                vd.setOfferHeading(rs.getString("offer_heading"));
                vd.setOfferDesc(rs.getString("offer_description"));
                vd.setStoreName(rs.getString("name"));
                vd.setStoreSeoUrl(rs.getString("seo_url"));
                vd.setOfferImage(rs.getString("image"));
                vd.setUsedCountToday(rs.getString("used_count_today"));
                vd.setViewType(rs.getString("view_type"));
                vd.setExclusive(rs.getString("exclusive_coupon"));
                if (rs.getDate("modified_at") != null) {
                    vd.setModifiedAt(sdf.format(rs.getDate("modified_at")));
                }

                offerListDomain.add(vd);
                m.put(rs.getString("category_id"), offerListDomain);
                map.put(rs.getString("domain_id"), m);
                prev = rs.getString("domain_id");
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static void loadDomainsCountryMobile(Db db, Map<String, List<Domains>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT TD.id,TD.domain_group_id,TD.theme_id,TD.name,TD.image,TD.domain_url,TD.fb_url,TD.twit_url,TD.pn_url,TD.gplus_url ,TD.analytics_code,TD.certificate ,TD.test_certificate,TD.currency_type,TD.logo,logo_small,TC.name AS country_name FROM vc_domain TD, gl_country TC WHERE TD.publish = 1 AND TC.id = TD.country_id AND TC.publish = 1 ORDER BY TC.name";
            rs = db.select().resultSet(query, (Object[])null);
            List<Domains> groupList = null;
            groupList = new ArrayList();

            while(rs.next()) {
                Domains dm = new Domains();
                dm.setId(rs.getString("id"));
                dm.setDomainGroupId(rs.getString("domain_group_id"));
                dm.setThemeId(rs.getString("theme_id"));
                dm.setName(rs.getString("name"));
                dm.setImage(rs.getString("image"));
                dm.setDomainUrl(rs.getString("domain_url"));
                dm.setFbLink(rs.getString("fb_url"));
                dm.setGpLink(rs.getString("gplus_url"));
                dm.setTwLink(rs.getString("twit_url"));
                dm.setPnLink(rs.getString("pn_url"));
                dm.setAnalyticsCode(rs.getString("analytics_code"));
                dm.setGuaranteeCertificate(rs.getString("certificate"));
                dm.setTestGuarantee(rs.getString("test_certificate"));
                dm.setCurrencyType(rs.getString("currency_type"));
                dm.setLogo(rs.getString("logo"));
                dm.setLogoMobile(rs.getString("logo_small"));
                dm.setCountryName(rs.getString("country_name"));
                groupList.add(dm);
            }

            map.put("1", groupList);
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }
    }

    public static void loadTopStoreMobile(Db db, Map<String, List<Store>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT COALESCE(TUCNT.offer_count,0) AS offer_count,TS.id,TS.affiliate_url,TS.affiliate_url,TS.domain_id,TS.image_small,TS.image_big,TS.banner_position,TS.banner_image_href,TS.banner_image_url,TS.banner_image_upload,TS.vote,TS.rating,TSL.language_id,TSL.name,TSL.seo_url AS seo_url11,TSL.about_store,TSL.meta_title,TSL.meta_description,TSL.meta_keywords,TSL.news,TSL.reasons_to_use,TSL.how_to_use_coupon,TS.fb_link,TS.gp_link,TS.pn_link,TS.tw_link,TS.cod,TS.netbank,TSL.money_back,TSEO.seo_url,TSL.guarantee_info FROM vc_store TS LEFT OUTER JOIN(SELECT COUNT(VO.id) AS offer_count, VO.store_id AS st_id,VO.domain_id FROM vc_offer VO,vc_domain_date  TD WHERE VO.domain_id = TD.D_Id AND VO.start_date <= TD.Curr_Date AND VO.end_date >= TD.Curr_Date AND VO.publish = 1 GROUP BY VO.domain_id,VO.store_id ORDER BY VO.domain_id,VO.store_id )AS TUCNT ON TUCNT.st_id = TS.id,vc_store_lang TSL,vc_domain_seo_config TSEO WHERE TS.trash = 0 AND TS.popular_store = 1 AND TS.publish = 1 AND TS.id = TSL.store_id AND TSEO.pagetype_fk = TS.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 ORDER BY TS.domain_id,TS.popular_store_priority,TS.priority";
            rs = db.select().resultSet(query, (Object[])null);
            List<Store> storeList = null;
            Map dupe = new HashMap();
            String prev = null;

            while(rs.next()) {
                Store store = new Store();
                store.setId(rs.getString("id"));
                store.setDomainId(rs.getString("domain_id"));
                if (dupe.get(store.getDomainId()) == null) {
                    if (prev != null) {
                        map.put(prev, storeList);
                    }

                    storeList = new ArrayList();
                    prev = store.getDomainId();
                    dupe.put(store.getDomainId(), "1");
                }

                store.setAffiliateUrl(rs.getString("affiliate_url"));
                store.setStoreUrl(rs.getString("affiliate_url"));
                store.setImageSmall(rs.getString("image_small"));
                store.setImageBig(rs.getString("image_big"));
                store.setBannerPosition(rs.getString("banner_position"));
                store.setBannerImageHref(rs.getString("banner_image_href"));
                store.setBannerImageUrl(rs.getString("banner_image_url"));
                store.setBannerImageUpload(rs.getString("banner_image_upload"));
                store.setLanguageId(rs.getString("language_id"));
                store.setName(rs.getString("name"));
                store.setSeoUrl(rs.getString("seo_url"));
                store.setAboutStore(rs.getString("about_store"));
                store.setMetaTitle(rs.getString("meta_title"));
                store.setMetaDescription(rs.getString("meta_description"));
                store.setMetaKeywords(rs.getString("meta_keywords"));
                store.setVote(rs.getString("vote"));
                store.setRating(rs.getString("rating"));
                store.setNews(rs.getString("news"));
                store.setReason(rs.getString("reasons_to_use"));
                store.setHowToUse(rs.getString("how_to_use_coupon"));
                store.setFbLink(rs.getString("fb_link"));
                store.setGpLink(rs.getString("gp_link"));
                store.setPnLink(rs.getString("pn_link"));
                store.setTwLink(rs.getString("tw_link"));
                store.setCod(rs.getString("cod"));
                store.setNetBank(rs.getString("netbank"));
                store.setMoneyBack(rs.getString("money_back"));
                store.setGuaranteeInfo(rs.getString("guarantee_info"));
                store.setOfferCount(rs.getString("offer_count"));
                storeList.add(store);
                map.put(rs.getString("domain_id"), storeList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static List<Store> loadStoreMobileByName(Db db, String domainId, String languageId, String name) throws SQLException {
        ResultSet rs = null;
        List<Store> storeList = new ArrayList();
        PreparedStatement psStore = null;
        String condition = "";

        try {
            if ("0-9".equals(name)) {
                condition = " AND TSL.name ~ '^[0-9]' ";
            } else {
                condition = " AND LOWER(TSL.name) LIKE LOWER(?) ";
            }

            String query = "SELECT COALESCE(TUCNT.offer_count,0) AS offer_count,TS.id,TS.affiliate_url,TS.affiliate_url,TS.domain_id,TS.image_small,TS.image_big,TS.banner_position,TS.banner_image_href,TS.banner_image_url,TS.banner_image_upload,TS.vote,TS.rating,TSL.language_id,TSL.name,TSL.seo_url AS seo_url11,TSL.about_store,TSL.meta_title,TSL.meta_description,TSL.meta_keywords,TSL.news,TSL.reasons_to_use,TSL.how_to_use_coupon,TS.fb_link,TS.gp_link,TS.pn_link,TS.tw_link,TS.cod,TS.netbank,TSL.money_back,TSEO.seo_url,TSL.guarantee_info FROM vc_store TS LEFT OUTER JOIN(SELECT COUNT(VO.id) AS offer_count, VO.store_id AS st_id,VO.domain_id FROM vc_offer VO WHERE VO.start_date <= current_date AND VO.end_date >= current_date AND VO.publish = 1 GROUP BY VO.domain_id,VO.store_id ORDER BY VO.domain_id,VO.store_id )AS TUCNT ON TUCNT.st_id = TS.id,vc_store_lang TSL,vc_domain_seo_config TSEO WHERE TS.trash = 0 AND TS.publish = 1 AND TS.id = TSL.store_id AND TSEO.pagetype_fk = TS.id AND TSEO.page_type = 3 AND TSEO.language_id = TSL.language_id AND TSEO.archieved = 0 AND TSL.language_id = ? AND TS.domain_id = ? " + condition + " ORDER BY TS.domain_id,TS.popular_store_priority,TS.priority";
            psStore = db.select().getPreparedStatement(query);
            psStore.clearParameters();
            psStore.setInt(1, Integer.parseInt(languageId));
            psStore.setInt(2, Integer.parseInt(domainId));
            if (!"0-9".equals(name)) {
                psStore.setString(3, name + "%");
            }

            rs = psStore.executeQuery();

            while(rs.next()) {
                Store store = new Store();
                store.setId(rs.getString("id"));
                store.setDomainId(rs.getString("domain_id"));
                store.setAffiliateUrl(rs.getString("affiliate_url"));
                store.setStoreUrl(rs.getString("affiliate_url"));
                store.setImageSmall(rs.getString("image_small"));
                store.setImageBig(rs.getString("image_big"));
                store.setBannerPosition(rs.getString("banner_position"));
                store.setBannerImageHref(rs.getString("banner_image_href"));
                store.setBannerImageUrl(rs.getString("banner_image_url"));
                store.setBannerImageUpload(rs.getString("banner_image_upload"));
                store.setLanguageId(rs.getString("language_id"));
                store.setName(rs.getString("name"));
                store.setSeoUrl(rs.getString("seo_url"));
                store.setAboutStore(rs.getString("about_store"));
                store.setMetaTitle(rs.getString("meta_title"));
                store.setMetaDescription(rs.getString("meta_description"));
                store.setMetaKeywords(rs.getString("meta_keywords"));
                store.setVote(rs.getString("vote"));
                store.setRating(rs.getString("rating"));
                store.setNews(rs.getString("news"));
                store.setReason(rs.getString("reasons_to_use"));
                store.setHowToUse(rs.getString("how_to_use_coupon"));
                store.setFbLink(rs.getString("fb_link"));
                store.setGpLink(rs.getString("gp_link"));
                store.setPnLink(rs.getString("pn_link"));
                store.setTwLink(rs.getString("tw_link"));
                store.setCod(rs.getString("cod"));
                store.setNetBank(rs.getString("netbank"));
                store.setMoneyBack(rs.getString("money_back"));
                store.setGuaranteeInfo(rs.getString("guarantee_info"));
                store.setOfferCount(rs.getString("offer_count"));
                storeList.add(store);
            }
        } finally {
            Cleaner.close(psStore);
            Cleaner.close(rs);
            db.select().clean();
        }

        return storeList;
    }

    public static Map<String, Map<String, String>> loadProductCatSeo(Db db, Map<String, Map<String, String>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id, FM.key, FM.name,FM.path, FM.priority FROM vc_feed_meta FM WHERE FM.object_type=1";
            rs = db.select().resultSet(query, (Object[])null);
            Map<String, String> seoMap = null;

            while(rs.next()) {
                seoMap = (Map)map.get(rs.getString("domain_id"));
                if (seoMap == null) {
                    seoMap = new HashMap();
                }

                ((Map)seoMap).put(rs.getString("key"), rs.getString("name").toLowerCase());
                map.put(rs.getString("domain_id"), seoMap);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

        return map;
    }

    public static void loadTopCatSeo(Db db, Map<String, List<ProductCategory>> cats) throws SQLException {
        cats.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id, FM.key, FM.name,FM.path, FM.spare1, FM.priority FROM vc_feed_meta FM WHERE FM.object_type=1 ORDER BY FM.priority";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                String path = rs.getString("path");
                if (null != path && path.split("\\|").length == 1) {
                    ProductCategory cat = new ProductCategory();
                    cat.setName(rs.getString("name"));
                    cat.setSeo(rs.getString("key"));
                    cat.setSpare1(rs.getString("spare1"));
                    List<ProductCategory> topCat = (List)cats.get(rs.getString("domain_id"));
                    if (topCat == null) {
                        topCat = new ArrayList();
                        ((List)topCat).add(cat);
                    } else {
                        ((List)topCat).add(cat);
                    }

                    cats.put(rs.getString("domain_id"), topCat);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static Map<String, Map<String, String>> loadProductCatPath(Db db, Map<String, Map<String, String>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id, FM.key, FM.name,FM.path, FM.priority FROM vc_feed_meta FM WHERE FM.object_type=1";
            rs = db.select().resultSet(query, (Object[])null);
            Map<String, String> pathMap = null;

            while(rs.next()) {
                pathMap = (Map)map.get(rs.getString("domain_id"));
                if (pathMap == null) {
                    pathMap = new HashMap();
                }

                ((Map)pathMap).put(rs.getString("key").toLowerCase(), rs.getString("path"));
                map.put(rs.getString("domain_id"), pathMap);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

        return map;
    }

    public static void loadTopBrandSeo(Db db, Map<String, List<ProductBrand>> brands) throws SQLException {
        brands.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id, FM.key, FM.name, FM.priority FROM vc_feed_meta FM WHERE  FM.object_type=2 AND FM.priority IS NOT NULL AND FM.priority<15";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                ProductBrand br = new ProductBrand();
                br.setName(rs.getString("name"));
                br.setSeo(rs.getString("key"));
                List<ProductBrand> topBrand = (List)brands.get(rs.getString("domain_id"));
                if (topBrand == null) {
                    topBrand = new ArrayList();
                }

                ((List)topBrand).add(br);
                brands.put(rs.getString("domain_id"), topBrand);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static Map<String, Map<String, String>> loadProductBrandSeo(Db db, Map<String, Map<String, String>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id, FM.key, FM.name, FM.priority FROM vc_feed_meta FM WHERE FM.object_type=2";
            rs = db.select().resultSet(query, (Object[])null);
            Map<String, String> seoMap = null;

            while(rs.next()) {
                seoMap = (Map)map.get(rs.getString("domain_id"));
                if (seoMap == null) {
                    seoMap = new HashMap();
                }

                ((Map)seoMap).put(rs.getString("key"), rs.getString("name"));
                map.put(rs.getString("domain_id"), seoMap);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

        return map;
    }

    public static void loadHomeContent(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        String query = "SELECT FM.id,FM.domain_id, FM.key, FM.content FROM vc_feed_meta FM WHERE FM.key='coupons' AND FM.object_type='5'";

        try {
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                map.put(rs.getString("domain_id"), rs.getString("content"));
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static Map<String, Map<String, FeedMeta>> loadFeedMeta(Db db, Map<String, Map<String, FeedMeta>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id, FM.key, FM.content, FM.title, FM.description, FM.keyword, FM.image,FM.h1, FM.top_content FROM vc_feed_meta FM";
            rs = db.select().resultSet(query, (Object[])null);
            Map<String, FeedMeta> feedMetaList = null;

            while(rs.next()) {
                FeedMeta feedMeta = new FeedMeta();
                feedMeta.setId(rs.getString("id"));
                feedMeta.setDomainId(rs.getString("domain_id"));
                feedMeta.setKey(rs.getString("key"));
                feedMeta.setContent(rs.getString("content"));
                feedMeta.setTitle(rs.getString("title"));
                feedMeta.setMetaKeyword(rs.getString("keyword"));
                feedMeta.setMetaDescription(rs.getString("description"));
                feedMeta.setImage(rs.getString("image"));
                feedMeta.setH1(rs.getString("h1"));
                feedMeta.setTopContent(rs.getString("top_content"));
                feedMetaList = (Map)map.get(rs.getString("domain_id"));
                if (feedMetaList == null) {
                    feedMetaList = new HashMap();
                }

                ((Map)feedMetaList).put(feedMeta.getKey(), feedMeta);
                map.put(rs.getString("domain_id"), feedMetaList);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

        return map;
    }

    static void loadCatProduct(Db db, Map<String, Map<String, List<Product>>> map, Map<String, List<ProductCategory>> topCat) {
        map.clear();
        Iterator var3 = topCat.entrySet().iterator();

        while(var3.hasNext()) {
            Map.Entry<String, List<ProductCategory>> entry = (Map.Entry)var3.next();
            VcHome home = VcHome.instance();
            String domainId = (String)entry.getKey();
            Map<String, List<Product>> tempaMap = (Map)map.get(domainId);
            Iterator var8 = ((List)topCat.get(domainId)).iterator();

            while(var8.hasNext()) {
                ProductCategory cat = (ProductCategory)var8.next();
                List<Domains> domains = home.getDomains(domainId);
                Domains domain = home.getDomain(domains, domainId);
                if ("FEED".equals(domain.getThemeType())) {
                    SolrDao<Product> solrDao = new SolrDao(domainId);
                    List<Product> products = solrDao.readTopProByCategory(SolrUtils.generateQuery(cat.getName()), cat.getSpare1(), SystemConstant.TOP_CAT_PARAMETER);
                    if (tempaMap == null) {
                        tempaMap = new HashMap();
                    }

                    ((Map)tempaMap).put(cat.getName(), products);
                    map.put(domainId, tempaMap);
                }
            }
        }

    }

    static void loadFeedTagMap(Db db, Map<String, Map<String, List<FeedMeta>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id,FM.object_type,FM.key, FM.content, FM.title, FM.description, FM.keyword, FM.image,FM.name,FM.path,FM.tag,FM.priority FROM vc_feed_meta FM WHERE FM.tag!=null OR FM.tag!='' order by FM.priority";
            rs = db.select().resultSet(query, (Object[])null);

            for(Map<String, List<FeedMeta>> tagFeedMetaListMap = null; rs.next(); map.put(rs.getString("domain_id"), tagFeedMetaListMap)) {
                FeedMeta feedMeta = new FeedMeta();
                feedMeta.setId(rs.getString("id"));
                feedMeta.setDomainId(rs.getString("domain_id"));
                feedMeta.setKey(rs.getString("key"));
                feedMeta.setContent(rs.getString("content"));
                feedMeta.setTitle(rs.getString("title"));
                feedMeta.setMetaKeyword(rs.getString("keyword"));
                feedMeta.setMetaDescription(rs.getString("description"));
                feedMeta.setName(rs.getString("name"));
                feedMeta.setPath(rs.getString("path"));
                feedMeta.setTag(rs.getString("tag"));
                feedMeta.setImage(rs.getString("image"));
                feedMeta.setPriority(rs.getInt("priority"));
                tagFeedMetaListMap = (Map)map.get(rs.getString("domain_id"));
                if (tagFeedMetaListMap != null) {
                    List<FeedMeta> feedMetaList = (List)((Map)tagFeedMetaListMap).get(rs.getString("tag"));
                    if (feedMetaList == null) {
                        feedMetaList = new ArrayList();
                    }

                    ((List)feedMetaList).add(feedMeta);
                    ((Map)tagFeedMetaListMap).put(rs.getString("tag"), feedMetaList);
                } else {
                    List<FeedMeta> feedMetaList = new ArrayList();
                    tagFeedMetaListMap = new LinkedHashMap();
                    feedMetaList.add(feedMeta);
                    ((Map)tagFeedMetaListMap).put(rs.getString("tag"), feedMetaList);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    static void loadAllBrand(Db db, Map<String, Map<String, List<ProductBrand>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.domain_id,FM.key,FM.name FROM vc_feed_meta FM WHERE FM.object_type=2 order by FM.key ";
            Map<String, List<ProductBrand>> productBrandListMap = null;

            for(rs = db.select().resultSet(query, (Object[])null); rs.next(); map.put(rs.getString("domain_id"), productBrandListMap)) {
                String brandAlph = rs.getString("name").substring(0, 1).toUpperCase();
                ProductBrand productBrand = new ProductBrand();
                productBrand.setName(rs.getString("name"));
                productBrand.setSeo(rs.getString("key"));
                productBrandListMap = (Map)map.get(rs.getString("domain_id"));
                if (productBrandListMap != null) {
                    List<ProductBrand> productBrandList = (List)((Map)productBrandListMap).get(brandAlph);
                    if (productBrandList != null) {
                        ((List)productBrandList).add(productBrand);
                    } else {
                        productBrandList = new ArrayList();
                        ((List)productBrandList).add(productBrand);
                    }

                    ((Map)productBrandListMap).put(brandAlph, productBrandList);
                } else {
                    productBrandListMap = new TreeMap();
                    List<ProductBrand> productBrandList = new ArrayList();
                    productBrandList.add(productBrand);
                    ((Map)productBrandListMap).put(brandAlph, productBrandList);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static Map<String, Map<String, List<MenuData>>> loadCategoryData(Db db, Map<String, Map<String, List<MenuData>>> menuDataMap) throws SQLException {
        menuDataMap.clear();
        Map<String, List<MenuData>> menuDataIntMap = null;
        ResultSet rs = null;

        try {
            String query = "SELECT FM.name, FM.domain_id, FM.key, FM.path FROM vc_feed_meta FM where FM.object_type=1 AND (FM.priority IS NULL OR FM.priority > -1)  ORDER BY FM.priority";

            for(rs = db.select().resultSet(query, (Object[])null); rs.next(); menuDataMap.put(rs.getString("domain_id"), menuDataIntMap)) {
                MenuData menuData = new MenuData();
                String var10001 = SystemConstant.ROOT_URL;
                menuData.setUrl("/" + var10001 + "/" + rs.getString("key"));
                menuData.setName(rs.getString("name"));
                menuData.setPath(rs.getString("path"));
                menuDataIntMap = (Map)menuDataMap.get(rs.getString("domain_id"));
                if (menuDataIntMap == null) {
                    menuDataIntMap = new HashMap();
                }

                String parent = "";
                if (null != menuData.getPath()) {
                    String[] categories = menuData.getPath().split("\\|");
                    switch (categories.length) {
                        case 1:
                            List<MenuData> rootCategories = (List)((Map)menuDataIntMap).get("root");
                            if (rootCategories == null) {
                                rootCategories = new ArrayList();
                            }

                            ((List)rootCategories).add(menuData);
                            ((Map)menuDataIntMap).put("root", rootCategories);
                            break;
                        case 2:
                            List<MenuData> subCategories = (List)((Map)menuDataIntMap).get("sub");
                            if (subCategories == null) {
                                subCategories = new ArrayList();
                            }

                            parent = categories[categories.length - 2];
                            menuData.setParent(parent);
                            ((List)subCategories).add(menuData);
                            ((Map)menuDataIntMap).put("sub", subCategories);
                            break;
                        case 3:
                            List<MenuData> endCategories = (List)((Map)menuDataIntMap).get("end");
                            if (endCategories == null) {
                                endCategories = new ArrayList();
                            }

                            parent = categories[categories.length - 2];
                            String rootParent = categories[categories.length - 3];
                            menuData.setParent(parent);
                            menuData.setRootParent(rootParent);
                            ((List)endCategories).add(menuData);
                            ((Map)menuDataIntMap).put("end", endCategories);
                    }
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

        return menuDataMap;
    }

    static void loadAllBrandsByCategory(Db db, Map<String, Map<String, List<ProductBrand>>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id,FM.spare1, FM.key, FM.name, FM.priority FROM vc_feed_meta FM WHERE  FM.object_type=2";
            rs = db.select().resultSet(query, (Object[])null);
            Map<String, List<ProductBrand>> productBrandListMap = null;

            while(rs.next()) {
                if (null != rs.getString("spare1")) {
                    ProductBrand productBrand = new ProductBrand();
                    productBrand.setName(rs.getString("name"));
                    productBrand.setSeo(rs.getString("key"));
                    productBrandListMap = (Map)map.get(rs.getString("domain_id"));
                    if (productBrandListMap == null) {
                        productBrandListMap = new HashMap();
                    }

                    String var10001 = SystemConstant.ROOT_URL;
                    List<ProductBrand> productBrandList = (List)((Map)productBrandListMap).get("/" + var10001 + "/" + rs.getString("spare1"));
                    if (productBrandList == null) {
                        productBrandList = new ArrayList();
                    }

                    ((List)productBrandList).add(productBrand);
                    ((Map)productBrandListMap).put("/" + SystemConstant.ROOT_URL + "/" + rs.getString("spare1"), productBrandList);
                    map.put(rs.getString("domain_id"), productBrandListMap);
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    static void loadSolrUrl(Db db, Map<String, String> map) throws SQLException {
        map.clear();
        ResultSet rs = null;
        String query = "";

        try {
            query = "SELECT id, solr_url FROM vc_domain";
            rs = db.select().resultSet(query, (Object[])null);

            while(rs.next()) {
                if (null != rs.getString(2) && !"".equals(rs.getString(2))) {
                    map.put(rs.getString(1), rs.getString(2));
                }
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

    }

    public static Map<String, Map<String, Integer>> loadProductCatBrandPriority(Db db, Map<String, Map<String, Integer>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id, FM.key, FM.name,FM.path, FM.priority FROM vc_feed_meta FM WHERE FM.object_type=3";
            rs = db.select().resultSet(query, (Object[])null);
            Map<String, Integer> seoMap = null;

            while(rs.next()) {
                seoMap = (Map)map.get(rs.getString("domain_id"));
                if (seoMap == null) {
                    seoMap = new HashMap();
                }

                ((Map)seoMap).put("/" + rs.getString("key"), rs.getInt("priority") == 0 ? 999 : rs.getInt("priority"));
                map.put(rs.getString("domain_id"), seoMap);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

        return map;
    }

    public static Map<String, Map<String, Integer>> loadProductCatPriority(Db db, Map<String, Map<String, Integer>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id, FM.key, FM.name,FM.path, FM.priority FROM vc_feed_meta FM WHERE FM.object_type=1";
            rs = db.select().resultSet(query, (Object[])null);
            Map<String, Integer> seoMap = null;

            while(rs.next()) {
                seoMap = (Map)map.get(rs.getString("domain_id"));
                if (seoMap == null) {
                    seoMap = new HashMap();
                }

                ((Map)seoMap).put("/" + rs.getString("key"), rs.getInt("priority") == 0 ? 999 : rs.getInt("priority"));
                map.put(rs.getString("domain_id"), seoMap);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

        return map;
    }

    public static Map<String, Map<String, Integer>> loadProductBrandPriority(Db db, Map<String, Map<String, Integer>> map) throws SQLException {
        map.clear();
        ResultSet rs = null;

        try {
            String query = "SELECT FM.id,FM.domain_id, FM.key, FM.name,FM.path, FM.priority FROM vc_feed_meta FM WHERE FM.object_type=2";
            rs = db.select().resultSet(query, (Object[])null);
            Map<String, Integer> seoMap = null;

            while(rs.next()) {
                seoMap = (Map)map.get(rs.getString("domain_id"));
                if (seoMap == null) {
                    seoMap = new HashMap();
                }

                ((Map)seoMap).put("/" + rs.getString("key"), rs.getInt("priority") == 0 ? 999 : rs.getInt("priority"));
                map.put(rs.getString("domain_id"), seoMap);
            }
        } finally {
            Cleaner.close(rs);
            db.select().clean();
        }

        return map;
    }
}
