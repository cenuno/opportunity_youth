def pullsqldata():
    """This function utilizes SQLalchemy to pull SQL queries into pandas dataframes"""
    from sqlalchemy import create_engine
    import pandas as pd
    engine = create_engine("postgresql:///opportunity_youth")
    queries = [("""SELECT * FROM oyyouth_from_pumas"""),
               ("""SELECT * FROM oy_age_counts"""), 
               ("""SELECT * FROM oy_age_counts_by_education"""),
               ("""SELECT * FROM oy_age_summary"""),
               ("""SELECT * FROM oy_education_summary""")]
    opp_youth = pd.read_sql(sql = queries[0], con = engine)
    total_population = pd.read_sql(sql = queries[1], con = engine)
    opportunity_youth = pd.read_sql(sql = queries[2], con = engine)
    poptotals = pd.read_sql(sql = queries[3], con = engine)
    OYtotals = pd.read_sql(sql = queries[4], con = engine)
    total_population['year'] = 2017
    opportunity_youth['year'] = 2017
    poptotals['year'] = 2017
    OYtotals['year'] = 2017
    pivot_total_youth_pop = total_population.pivot(index = 'oy_flag', 
                                                   columns = 'age_flag', 
                                                   values = ['estimate', 'total', 'percent'])
    pivot_total_youth_pop.to_csv("./data/processed/total_youth_statistics_2017.csv")
    poptotals.to_csv("./data/processed/youth_population_summary_2017.csv")
    pivot_opportunity_youth = opportunity_youth.pivot(index = 'edu_flag', 
                                                      columns = 'age_flag', 
                                                      values = ['estimate', 'total', 'percent'])
    pivot_opportunity_youth.to_csv("./data/processed/opportunity_youth_education_2017")
    OYtotals.to_csv("./data/processed/opportunity_youth_education_summary.csv")
    
    #Read in the data from the 2016 report (copied from the report into a spreadsheet)
    educationtable2014 = pd.read_csv("./data/processed/2016educationtable - Sheet1.csv")
    educationtabletotals2014 = pd.read_csv("./data/processed/2016educationtable_totals - Sheet1.csv")
    opyouthtable2014 = pd.read_csv("./data/processed/2016opportunityyouthtable - Sheet1.csv")
    opyouthtabletotals2014 = pd.read_csv("./data/processed/2016opportunityyouthtable_totals - Sheet1.csv")
    #Add year columns to the 2016 data
    opyouthtable2014['year'] = 2014
    opyouthtabletotals2014['year'] = 2014
    educationtable2014['year'] = 2014
    educationtabletotals2014['year'] = 2014
    #Concatenate both years into the two tables for comparison and visualization 
    youth_population_2014_2017 = pd.concat([total_population, opyouthtable2014], ignore_index= True)
    youth_population_totals_2014_2017 = pd.concat([poptotals, opyouthtabletotals2014], ignore_index= True)
    oy_population_2014_2017 = pd.concat([opportunity_youth, educationtable2014], ignore_index= True)
    oy_population_totals_2014_2017 = pd.concat([OYtotals, educationtabletotals2014], ignore_index= True)
    return opp_youth, total_population, poptotals, opportunity_youth, OYtotals, pivot_total_youth_pop, pivot_opportunity_youth, youth_population_2014_2017, youth_population_totals_2014_2017, oy_population_2014_2017, oy_population_totals_2014_2017

def plotdata1(df):
    """This function plots the data gathered and parsed in the pullsqldata() function"""
    import seaborn as sns
    import matplotlib.pyplot as plt 
    import pandas as pd
    sns.set_style('darkgrid')
    style = 'seaborn-darkgrid'
    plt.style.use(style)
    #Plot total youth population in 2014 vs. 2017 - show that population has decreased
    fig, ax = plt.subplots(figsize = (5, 5), dpi = 100)
    sns.barplot(x = 'year',
                y = 'total_population',
                data = df)
    plt.title('Total Population of Youth \n Ages 16-24 in South King Co.')
    plt.ylabel('Population')
    plt.yticks(fontsize = 'x-small')
    plt.xlabel('Year')
    plt.tight_layout()
    plt.savefig("totalpop.png", dpi = 300)
    return fig, ax

def plotdata2(df):
    """This function plots the data gathered and parsed in the pullsqldata() function"""
    import seaborn as sns
    import matplotlib.pyplot as plt 
    import pandas as pd
    sns.set_style('darkgrid')
    style = 'seaborn-darkgrid'
    plt.style.use(style)
    #Plot percent OY population in 2014 vs. 2017 - show that even though population has decreased, the proportion of
    #OY youth has also decreased slightly
    fig, ax = plt.subplots(figsize = (5, 5), dpi = 100)

    sns.barplot(x = 'year',
                y = 'percent',
                data = df.loc[df['oy_flag'] == 'OY'])
    plt.title("Percent of Opportunity Youth in \n South King Co. between 2014 and 2017", wrap = True)
    plt.ylabel('Percent Population')
    plt.yticks(fontsize = 'x-small')
    plt.xlabel('Year')
    plt.tight_layout()
    plt.savefig("percentOY.png", dpi = 300);
    return fig, ax