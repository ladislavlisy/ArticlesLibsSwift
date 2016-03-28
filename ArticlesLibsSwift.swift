import Foundation

public enum ConfigArticleCode : Int
{
    case ARTICLE_UNKNOWN = 0
    case ARTICLE_CONTRACT_EMPL_TERM = 101
    case ARTICLE_POSITION_EMPL_TERM = 110
    case ARTICLE_INCOME_GROSS = 501
    case ARTICLE_INCOME_NETTO = 502
    case ARTICLE_CONTRACT_STAT_TERM = 102
    case ARTICLE_CONTRACT_WORK_TERM = 103
    case ARTICLE_CONTRACT_TASK_TERM = 104
    case ARTICLE_SCHEDULE_WORK = 201
    case ARTICLE_SALARY_BASE = 202
    case ARTICLE_TIMESHEET_SCHEDULE = 251
    case ARTICLE_TIMESHEET_WORKING = 252
    case ARTICLE_TIMESHEET_ABSENCE = 253
    case ARTICLE_TIMEHOURS_WORKING = 254
    case ARTICLE_TIMEHOURS_ABSENCE = 255
    case ARTICLE_HEALTH_INCOME_SUBJECT = 301
    case ARTICLE_SOCIAL_INCOME_SUBJECT = 302
    case ARTICLE_GARANT_INCOME_SUBJECT = 303
    case ARTICLE_HEALTH_INCOME_PARTICIP = 305
    case ARTICLE_SOCIAL_INCOME_PARTICIP = 306
    case ARTICLE_GARANT_INCOME_PARTICIP = 307
    case ARTICLE_HEALTH_BASIS_GENERAL = 311
    case ARTICLE_HEALTH_BASIS_MANDATORY = 312
    case ARTICLE_HEALTH_BASIS_LEGALCAP = 313
    case ARTICLE_SOCIAL_BASIS_GENERAL = 321
    case ARTICLE_SOCIAL_BASIS_PENSION = 322
    case ARTICLE_SOCIAL_BASIS_LEGALCAP = 323
    case ARTICLE_GARANT_BASIS_PENSION = 331
    case ARTICLE_GARANT_BASIS_LEGALCAP = 332
    case ARTICLE_HEALTH_EMPLOYEE_GENERAL = 341
    case ARTICLE_HEALTH_EMPLOYEE_MANDATORY = 342
    case ARTICLE_SOCIAL_EMPLOYEE_GENERAL = 351
    case ARTICLE_SOCIAL_EMPLOYEE_PENSION = 352
    case ARTICLE_GARANT_EMPLOYEE_PENSION = 361
    case ARTICLE_HEALTH_EMPLOYER_GEENRAL = 371
    case ARTICLE_HEALTH_EMPLOYER_MANDATORY = 372
    case ARTICLE_SOCIAL_EMPLOYER_GENERAL = 373
    case ARTICLE_TAXING_INCOME_SUBJECT = 401
    case ARTICLE_TAXING_INCOME_HEALTH = 402
    case ARTICLE_TAXING_INCOME_SOCIAL = 403
    case ARTICLE_TAXING_ADVANCES_INCOME = 411
    case ARTICLE_TAXING_ADVANCES_HEALTH = 412
    case ARTICLE_TAXING_ADVANCES_SOCIAL = 413
    case ARTICLE_TAXING_ADVANCES_BASIS_GENERAL = 414
    case ARTICLE_TAXING_ADVANCES_BASIS_SOLIDARY = 415
    case ARTICLE_TAXING_ADVANCES_GENERAL = 416
    case ARTICLE_TAXING_ADVANCES_SOLIDARY = 417
    case ARTICLE_TAXING_ADVANCES_TOTAL = 418
    case ARTICLE_TAXING_ALLOWANCE_PAYER = 421
    case ARTICLE_TAXING_ALLOWANCE_CHILD = 422
    case ARTICLE_TAXING_ALLOWANCE_DISABILITY = 423
    case ARTICLE_TAXING_ALLOWANCE_STUDYING = 424
    case ARTICLE_TAXING_REBATE_PAYER = 431
    case ARTICLE_TAXING_REBATE_CHILD = 432
    case ARTICLE_TAXING_BONUS_CHILD = 433
    case ARTICLE_TAXING_WITHHOLD_INCOME = 451
    case ARTICLE_TAXING_WITHHOLD_HEALTH = 452
    case ARTICLE_TAXING_WITHHOLD_SOCIAL = 453
    case ARTICLE_TAXING_WITHHOLD_BASIS_GENERAL = 454
    case ARTICLE_TAXING_WITHHOLD_GENERAL = 456
}

public enum ProcessCategory : Int
{
    case CATEGORY_TERMS  = 0
    case CATEGORY_START  = 1
    case CATEGORY_TIMES  = 2
    case CATEGORY_AMOUNT = 3
    case CATEGORY_GROSS  = 4
    case CATEGORY_NETTO  = 5
    case CATEGORY_FINAL  = 9
}

public class Article: Equatable, Comparable, CustomDebugStringConvertible
{
    private let code: ConfigArticleCode;
    
    private let category : ProcessCategory;
    
    private let pendingCodes: Array<ConfigArticleCode>;
    
    init (code: ConfigArticleCode, catg: ProcessCategory, pendings: Array<ConfigArticleCode>)
    {
        self.code = code;
        
        self.category = catg;
        
        self.pendingCodes = pendings;
    }
    
    public func articleCode() -> ConfigArticleCode {
        return self.code;
    }
    
    public func articlePendings() -> Array<ConfigArticleCode> {
        return self.pendingCodes;
    }
    
    public var debugDescription: String {
        return "\(code.rawValue)";
    }
    
    func compareTo(other: Article) -> Int {
        return code.rawValue - other.code.rawValue;
    }
    
}

public func == (first: Article, other: Article) -> Bool {
    return (first.compareTo(other) == 0);
}

public func != (first: Article, other: Article) -> Bool {
    return (first.compareTo(other) != 0);
}

public func > (first: Article, other: Article) -> Bool {
    return (first.compareTo(other) > 0);
}

public func >= (first: Article, other: Article) -> Bool {
    return (first.compareTo(other) >= 0);
}

public func < (first: Article, other: Article) -> Bool {
    return (first.compareTo(other) < 0);
}

public func <= (first: Article, other: Article) -> Bool {
    return (first.compareTo(other) <= 0);
}

public class ProcessConfigArticles
{
    public init ()
    {
    }
    
    private let EMPTY_PENDING_NAMES: Array<ConfigArticleCode> = [];
    
    public func ConfigureArticles() -> Array<Article>
    {
        let articlesArray = Array([
            ConfigureContractTermArticles(),
            
            ConfigurePositionTimeArticles(),
            
            ConfigureGrossIncomeArticles(),
            
            ConfigureTotalIncomeArticles(),
            
            ConfigureNettoDeductsArticles(),
            
            ConfigureBasisHealthArticles(),
            
            ConfigureBasisSocialArticles(),
            
            ConfigureBasisGarantArticles(),
            
            ConfigureBasisTaxingArticles(),
            
            ConfigureBasisAdvancesArticles(),
            
            ConfigureBasisWithholdArticles(),
            
            ConfigureAllowanceTaxisArticles(),
            ConfigureRebateTaxisArticles()
            ].flatten());
        
        return articlesArray;
    }
    
    private func ConfigureContractTermArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_TERMS;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_CONTRACT_EMPL_TERM, catg: configCategory,
                pendings: EMPTY_PENDING_NAMES),
            Article(code: ConfigArticleCode.ARTICLE_POSITION_EMPL_TERM, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_CONTRACT_EMPL_TERM
                )
            )
        ];
        return articleArray;
    }
    
    private func ConfigurePositionTimeArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_TIMES;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_SCHEDULE_WORK, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_POSITION_EMPL_TERM
                )),
            Article(code: ConfigArticleCode.ARTICLE_TIMESHEET_SCHEDULE, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_SCHEDULE_WORK
                )),
            Article(code: ConfigArticleCode.ARTICLE_TIMESHEET_WORKING, catg: configCategory,
                pendings: PendingArticleNames2(
                    ConfigArticleCode.ARTICLE_TIMESHEET_SCHEDULE,
                    code2: ConfigArticleCode.ARTICLE_POSITION_EMPL_TERM
                )),
            Article(code: ConfigArticleCode.ARTICLE_TIMESHEET_ABSENCE, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TIMESHEET_WORKING
                )),
            Article(code: ConfigArticleCode.ARTICLE_TIMEHOURS_WORKING, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TIMESHEET_WORKING
                )),
            Article(code: ConfigArticleCode.ARTICLE_TIMEHOURS_ABSENCE, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TIMESHEET_ABSENCE
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureGrossIncomeArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_AMOUNT;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_SALARY_BASE, catg: configCategory,
                pendings: PendingArticleNames2(
                    ConfigArticleCode.ARTICLE_TIMEHOURS_WORKING,
                    code2: ConfigArticleCode.ARTICLE_TIMEHOURS_ABSENCE
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureTotalIncomeArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_FINAL;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_INCOME_GROSS, catg: configCategory,
                pendings: EMPTY_PENDING_NAMES),
            Article(code: ConfigArticleCode.ARTICLE_INCOME_NETTO, catg: configCategory,
                pendings: PendingArticleNames9(
                    ConfigArticleCode.ARTICLE_INCOME_GROSS,
                    code2: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_TOTAL,
                    code3: ConfigArticleCode.ARTICLE_TAXING_BONUS_CHILD,
                    code4: ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_GENERAL,
                    code5: ConfigArticleCode.ARTICLE_HEALTH_EMPLOYEE_GENERAL,
                    code6: ConfigArticleCode.ARTICLE_HEALTH_EMPLOYEE_MANDATORY,
                    code7: ConfigArticleCode.ARTICLE_SOCIAL_EMPLOYEE_GENERAL,
                    code8: ConfigArticleCode.ARTICLE_SOCIAL_EMPLOYEE_PENSION,
                    code9: ConfigArticleCode.ARTICLE_GARANT_EMPLOYEE_PENSION
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureNettoDeductsArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_NETTO;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_TOTAL, catg: configCategory,
                pendings: PendingArticleNames2(
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_GENERAL,
                    code2: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_SOLIDARY
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_GENERAL, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_BASIS_GENERAL
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_SOLIDARY, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_BASIS_SOLIDARY
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_GENERAL, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_BASIS_GENERAL
                )),
            Article(code: ConfigArticleCode.ARTICLE_HEALTH_EMPLOYEE_GENERAL, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_HEALTH_BASIS_GENERAL
                )),
            Article(code: ConfigArticleCode.ARTICLE_HEALTH_EMPLOYEE_MANDATORY, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_HEALTH_BASIS_MANDATORY
                )),
            Article(code: ConfigArticleCode.ARTICLE_SOCIAL_EMPLOYEE_GENERAL, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_SOCIAL_BASIS_GENERAL
                )),
            Article(code: ConfigArticleCode.ARTICLE_SOCIAL_EMPLOYEE_PENSION, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_SOCIAL_BASIS_PENSION
                )),
            Article(code: ConfigArticleCode.ARTICLE_GARANT_EMPLOYEE_PENSION, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_GARANT_BASIS_PENSION
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureBasisHealthArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_NETTO;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_HEALTH_INCOME_SUBJECT, catg: configCategory,
                pendings: EMPTY_PENDING_NAMES),
            Article(code: ConfigArticleCode.ARTICLE_HEALTH_INCOME_PARTICIP, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_HEALTH_INCOME_SUBJECT
                )),
            Article(code: ConfigArticleCode.ARTICLE_HEALTH_BASIS_GENERAL, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_HEALTH_INCOME_PARTICIP
                )),
            Article(code: ConfigArticleCode.ARTICLE_HEALTH_BASIS_MANDATORY, catg: configCategory,
                pendings: PendingArticleNames2(
                    ConfigArticleCode.ARTICLE_HEALTH_BASIS_GENERAL,
                    code2: ConfigArticleCode.ARTICLE_HEALTH_INCOME_PARTICIP
                )),
            Article(code: ConfigArticleCode.ARTICLE_HEALTH_BASIS_LEGALCAP, catg: configCategory,
                pendings: PendingArticleNames2(
                    ConfigArticleCode.ARTICLE_HEALTH_BASIS_GENERAL,
                    code2: ConfigArticleCode.ARTICLE_HEALTH_INCOME_PARTICIP
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureBasisSocialArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_NETTO;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_SOCIAL_INCOME_SUBJECT, catg: configCategory,
                pendings: EMPTY_PENDING_NAMES),
            Article(code: ConfigArticleCode.ARTICLE_SOCIAL_INCOME_PARTICIP, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_SOCIAL_INCOME_SUBJECT
                )),
            Article(code: ConfigArticleCode.ARTICLE_SOCIAL_BASIS_GENERAL, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_SOCIAL_INCOME_PARTICIP
                )),
            Article(code: ConfigArticleCode.ARTICLE_SOCIAL_BASIS_PENSION, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_SOCIAL_INCOME_PARTICIP
                )),
            Article(code: ConfigArticleCode.ARTICLE_SOCIAL_BASIS_LEGALCAP, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_SOCIAL_INCOME_PARTICIP
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureBasisGarantArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_NETTO;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_GARANT_INCOME_SUBJECT, catg: configCategory,
                pendings: EMPTY_PENDING_NAMES),
            Article(code: ConfigArticleCode.ARTICLE_GARANT_INCOME_PARTICIP, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_GARANT_INCOME_SUBJECT
                )),
            Article(code: ConfigArticleCode.ARTICLE_GARANT_BASIS_PENSION, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_GARANT_INCOME_PARTICIP
                )),
            Article(code: ConfigArticleCode.ARTICLE_GARANT_BASIS_LEGALCAP, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_GARANT_INCOME_PARTICIP
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureBasisTaxingArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_NETTO;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_TAXING_INCOME_SUBJECT, catg: configCategory,
                pendings: EMPTY_PENDING_NAMES),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_INCOME_HEALTH, catg: configCategory,
                pendings: EMPTY_PENDING_NAMES),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_INCOME_SOCIAL, catg: configCategory,
                pendings: EMPTY_PENDING_NAMES)
        ];
        return articleArray;
    }
    
    private func ConfigureBasisAdvancesArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_NETTO;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_INCOME, catg: configCategory,
                pendings: PendingArticleNames1 (
                    ConfigArticleCode.ARTICLE_TAXING_INCOME_SUBJECT
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_HEALTH, catg: configCategory,
                pendings: PendingArticleNames1 (
                    ConfigArticleCode.ARTICLE_TAXING_INCOME_HEALTH
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_SOCIAL, catg: configCategory,
                pendings: PendingArticleNames1 (
                    ConfigArticleCode.ARTICLE_TAXING_INCOME_SOCIAL
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_BASIS_GENERAL, catg: configCategory,
                pendings: PendingArticleNames3 (
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_INCOME,
                    code2: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_HEALTH,
                    code3: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_SOCIAL
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_BASIS_SOLIDARY, catg: configCategory,
                pendings: PendingArticleNames1 (
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_BASIS_GENERAL
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureBasisWithholdArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_NETTO;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_INCOME, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_INCOME_SUBJECT
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_HEALTH, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_INCOME_HEALTH
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_SOCIAL, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_INCOME_SOCIAL
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_BASIS_GENERAL, catg: configCategory,
                pendings: PendingArticleNames3(
                    ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_INCOME,
                    code2: ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_HEALTH,
                    code3: ConfigArticleCode.ARTICLE_TAXING_WITHHOLD_SOCIAL
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureAllowanceTaxisArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_NETTO;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ALLOWANCE_PAYER, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_INCOME
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ALLOWANCE_DISABILITY, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_INCOME
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ALLOWANCE_STUDYING, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_INCOME
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_ALLOWANCE_CHILD, catg: configCategory,
                pendings: PendingArticleNames1(
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_INCOME
                ))
        ];
        return articleArray;
    }
    
    private func ConfigureRebateTaxisArticles() -> Array<Article>
    {
        let configCategory : ProcessCategory = ProcessCategory.CATEGORY_NETTO;
        
        let articleArray = [
            Article(code: ConfigArticleCode.ARTICLE_TAXING_REBATE_PAYER, catg: configCategory,
                pendings: PendingArticleNames4(
                    ConfigArticleCode.ARTICLE_TAXING_ALLOWANCE_PAYER,
                    code2: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_TOTAL,
                    code3: ConfigArticleCode.ARTICLE_TAXING_ALLOWANCE_DISABILITY,
                    code4: ConfigArticleCode.ARTICLE_TAXING_ALLOWANCE_STUDYING
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_REBATE_CHILD, catg: configCategory,
                pendings: PendingArticleNames3(
                    ConfigArticleCode.ARTICLE_TAXING_ALLOWANCE_CHILD,
                    code2: ConfigArticleCode.ARTICLE_TAXING_ADVANCES_TOTAL,
                    code3: ConfigArticleCode.ARTICLE_TAXING_REBATE_PAYER
                )),
            Article(code: ConfigArticleCode.ARTICLE_TAXING_BONUS_CHILD, catg: configCategory,
                pendings: PendingArticleNames3(
                    ConfigArticleCode.ARTICLE_TAXING_ADVANCES_TOTAL,
                    code2: ConfigArticleCode.ARTICLE_TAXING_REBATE_PAYER,
                    code3: ConfigArticleCode.ARTICLE_TAXING_REBATE_CHILD
                ))
        ];
        return articleArray;
    }
    
    public func PendingArticleNames1(code1: ConfigArticleCode) -> Array<ConfigArticleCode>
    {
        return [ code1 ];
    }
    public func PendingArticleNames2(code1: ConfigArticleCode, code2: ConfigArticleCode) -> Array<ConfigArticleCode>
    {
        return [ code1, code2 ];
    }
    public func PendingArticleNames3(code1: ConfigArticleCode, code2: ConfigArticleCode, code3: ConfigArticleCode) -> Array<ConfigArticleCode>
    {
        return [ code1, code2, code3 ];
    }
    public func PendingArticleNames4(code1: ConfigArticleCode, code2: ConfigArticleCode, code3: ConfigArticleCode, code4: ConfigArticleCode) -> Array<ConfigArticleCode>
    {
        return [ code1, code2, code3, code4 ];
    }
    public func PendingArticleNames5(code1: ConfigArticleCode, code2: ConfigArticleCode, code3: ConfigArticleCode, code4: ConfigArticleCode,
                                     code5: ConfigArticleCode) -> Array<ConfigArticleCode>
    {
        return [ code1, code2, code3, code4, code5 ];
    }
    public func PendingArticleNames9(code1: ConfigArticleCode, code2: ConfigArticleCode, code3: ConfigArticleCode, code4: ConfigArticleCode,
                                     code5: ConfigArticleCode, code6: ConfigArticleCode, code7: ConfigArticleCode, code8: ConfigArticleCode, code9: ConfigArticleCode) -> Array<ConfigArticleCode>
    {
        return [ code1, code2, code3, code4, code5, code6, code7, code8, code9 ];
    }
}

