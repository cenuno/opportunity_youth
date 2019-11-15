def pullsqldata():
    """This function utilizes SQLalchemy to pull SQL queries into pandas dataframes"""
    from sqlalchemy import create_engine
    import pandas as pd
    engine = create_engine("postgresql:///opportunity_youth")
    queries = [("""SELECT * FROM oyyouth_from_pumas"""),
               ("""SELECT * FROM oy_age_counts"""), 
               ("""SELECT * FROM oy_age_counts_by_education"""),
               ("""SELECT * FROM oy_age_summary"""),
               ("""SELECT * FROM oy_education_summary"""),
               ("""SELECT * FROM total_youth""")]
    opp_youth = pd.read_sql(sql = queries[0], con = engine)
    total_population = pd.read_sql(sql = queries[1], con = engine)
    opportunity_youth = pd.read_sql(sql = queries[2], con = engine)
    poptotals = pd.read_sql(sql = queries[3], con = engine)
    OYtotals = pd.read_sql(sql = queries[4], con = engine)
    total_youth = pd.read_sql(sql = queries[5], con = engine)
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
    return opp_youth, total_population, poptotals, opportunity_youth, OYtotals, pivot_total_youth_pop, pivot_opportunity_youth, youth_population_2014_2017, youth_population_totals_2014_2017, oy_population_2014_2017, oy_population_totals_2014_2017, total_youth

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

def plotdata3(df):
    """This function plots the data gathered and parsed in the pullsqldata() function"""
    import seaborn as sns
    import matplotlib.pyplot as plt 
    import pandas as pd
    sns.set_style('darkgrid')
    style = 'seaborn-darkgrid'
    plt.style.use(style)
    fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize = (15, 5), dpi = 100)

    sns.barplot(x = 'age_flag',
                y = 'percent',
                hue = 'year',
                data = df.loc[df['oy_flag'] == 'Not OY'],
                ax = ax1)
    ax1.set_title("Not Opportunity Youth")
    ax1.set_xlabel("")
    ax1.set_ylabel("Percent Population")
    ax1.set_ylim(0, 100)

    sns.barplot(x = 'age_flag',
                    y = 'percent',
                    hue = 'year',
                    data = df.loc[df['oy_flag'] == 'Working without diploma'],
                ax = ax3)
    ax3.set_title("Working without Diploma")
    ax3.set_xlabel("")
    ax3.set_ylabel("")
    ax3.set_ylim(0, 100)

    sns.barplot(x = 'age_flag',
                    y = 'percent',
                    hue = 'year',
                    data = df.loc[df['oy_flag'] == 'OY'],
                ax = ax2)
    ax2.set_title("Opportunity Youth")
    ax2.set_xlabel("")
    ax2.set_ylabel("")
    ax2.set_ylim(0, 100)

    plt.tight_layout()
    plt.savefig("YouthPopulationbyAge.png", dpi = 300)
    return fig, ax1, ax2, ax3

def plotdata4(df):
    """This function plots the data gathered and parsed in the pullsqldata() function"""
    import seaborn as sns
    import matplotlib.pyplot as plt 
    import pandas as pd
    sns.set_style('darkgrid')
    style = 'seaborn-darkgrid'
    plt.style.use(style)
    fig, ax1 = plt.subplots(figsize = (5, 5), dpi = 100)

    sns.barplot(x = 'age_flag',
                    y = 'percent',
                    hue = 'year',
                    data = df.loc[df['oy_flag'] == 'OY'],
                ax = ax1)
    ax1.set_title("Opportunity Youth by Age")
    ax1.set_xlabel("")
    ax1.set_ylabel("Percent of Youth Population")
    ax1.set_ylim(0, 25)

    plt.tight_layout()
    plt.savefig("OppYouthPopulationbyAge.png", dpi = 300)
    return fig, ax1

def plotdata5(df):
    """This function plots the data gathered and parsed in the pullsqldata() function"""
    import seaborn as sns
    import matplotlib.pyplot as plt 
    import pandas as pd
    sns.set_style('darkgrid')
    style = 'seaborn-darkgrid'
    plt.style.use(style)
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize = (8, 8), dpi = 100)

    sns.barplot(x = 'year',
                y = 'percent',
                data = df.loc[df['edu_flag'] == 'No Diploma'],
                ax = ax1)
    ax1.set_title("Opportunity Youth without a Diploma")
    ax1.set_xlabel("Year")
    ax1.set_ylabel("Percent of Opportunity Youth")
    ax1.set_ylim(0, 50)

    sns.barplot(x = 'year',
                y = 'percent',
                data = df.loc[df['edu_flag'] == 'HS Diploma or GED'],
                ax = ax2)
    ax2.set_title("Opportunity Youth with a HS Diploma or GED")
    ax2.set_xlabel("Year")
    ax2.set_ylabel("")
    ax2.set_ylim(0, 50)

    sns.barplot(x = 'year',
                y = 'percent',
                data = df.loc[df['edu_flag'] == 'College but no degree'],
                ax = ax3)
    ax3.set_title("Opportunity Youth with College \n Credits but no Degree")
    ax3.set_xlabel("Year")
    ax3.set_ylabel("Percent of Opportunity Youth")
    ax3.set_ylim(0, 50)

    sns.barplot(x = 'year',
                y = 'percent',
                data = df.loc[df['edu_flag'] == 'College Degree Holder'],
                ax = ax4)
    ax4.set_title("Opportunity Youth with \n College Degree (Associates or Higher)")
    ax4.set_xlabel("Year")
    ax4.set_ylabel("")
    ax4.set_ylim(0, 50)

    plt.tight_layout()
    plt.savefig("OpportunityYouthEducation.png", dpi = 300)
    return fig, ax1, ax2, ax3, ax4

def is_county(puma):
    
    '''This function takes a string input and checks if it is in King County
    or South King County. 
    
    It returns a 0 for the greater washinton area, 1 for King County areas that are NOT south king county
   and 2 for South King County. It is meant to use as apart of a .map(lambda) style syntax to apply across a Pandas Datafram.
   
   puma_arg can be a single puma id number or a list. It must be a string.'''
   
    king_counties = ['11601', '11602', '11603','11606', '11607', '11608', '11609', '11610', '11611', '11612', '11613', '11614', '11615', '11616'] 
    s_king_counties = ['11610', '11613', '11614', '11615', '11611', '11612', '11604','11605']
    if puma in s_king_counties:
        return 2
    elif puma in king_counties:
        return 1
    else:
        return 0

def make_locator_map():
    import geopandas
    from matplotlib import pyplot as plt
    import folium
    from mpl_toolkits.axes_grid1 import make_axes_locatable
    import pandas as pd

    wa_puma = geopandas.read_file("data/raw/tl_2017_53_puma10.shp")
    wa_puma = wa_puma.to_crs(epsg='3857')

    wa_puma["king_county"]=wa_puma["PUMACE10"].map(lambda x: is_county(x))

    s_king_df = wa_puma.loc[wa_puma['king_county']==2]

    sm = folium.Map([47.5, -122.3502], zoom_start=9.4, crs='EPSG3857', zoom_control = False)

    folium.GeoJson(s_king_df).add_to(sm)
    sm.save('S_King_County_Locator_Map.html')
    return sm


def prepare_df_for_choropleth (df1,df2):
    import geopandas
    from matplotlib import pyplot as plt
    import folium
    from mpl_toolkits.axes_grid1 import make_axes_locatable
    import pandas as pd

    OYbyPUMA = df1.groupby('puma')['pwgtp'].sum()
    wa_puma = geopandas.read_file("data/raw/tl_2017_53_puma10.shp")
    wa_puma = wa_puma.to_crs(epsg='3857')

    wa_puma["king_county"]=wa_puma["PUMACE10"].map(lambda x: is_county(x))

    s_king_df = wa_puma.loc[wa_puma['king_county']==2]
    s_king_df.index = s_king_df['PUMACE10'] #reset the s_king_df index to be the puma id
    OYbyPUMA_df = pd.DataFrame(OYbyPUMA)#create the dataframe containing the estimated # of OY
    s_king_df = s_king_df.join(OYbyPUMA_df, how='left') #join them together
    total_byPUMA = df2.groupby('puma')['pwgtp'].sum()
    total_byPUMA_df = pd.DataFrame(total_byPUMA)
    total_byPUMA_df = total_byPUMA_df.rename(columns={'pwgtp':'total_youth_pop'})
    s_king_df = s_king_df.join(total_byPUMA_df, how='left') 
    s_king_df['OY_percent']=round(s_king_df['pwgtp']/s_king_df['total_youth_pop']*100)

    return s_king_df



def make_choropleth_OYpop_map(geo_df):
    '''this function outputs a choropleth map visualizing the total oy pop
        per puma region'''
    import geopandas
    from matplotlib import pyplot as plt
    import folium
    from mpl_toolkits.axes_grid1 import make_axes_locatable
    import pandas as pd
    fig, ax = plt.subplots(1,1)
    fig.set_size_inches(22,17)

    ax.set_yticklabels([])
    ax.set_ylabel(' ')

    ax.set_xticklabels([])
    ax.set_xlabel(' ')

    ax.set_title("""Estimated Opportunity Youth \n by PUMA in S. King County""", 
                fontdict = {'fontsize':'48'},
                pad=20)
    divider = make_axes_locatable(ax)
    cax = divider.append_axes("right", size="5%", pad=0.1)

    geo_df.plot(column = "pwgtp", ax=ax, cmap = "YlOrBr", legend = True, cax = cax,
                edgecolor ='black')

    plt.savefig("OY_by_puma_map.png", dpi =200) 
    return fig, ax

def make_choropleth_percentOY_map(geo_df):
    ''' This function builds a choropleth map visualizing the percent oy youth by puma'''
    import geopandas
    from matplotlib import pyplot as plt
    import folium
    from mpl_toolkits.axes_grid1 import make_axes_locatable
    import pandas as pd
    fig_2, ax_2 = plt.subplots(1,1)
    fig_2.set_size_inches(22,17)


    ax_2.set_yticklabels([])
    ax_2.set_ylabel(" " )

    ax_2.set_xticklabels([])
    ax_2.set_xlabel(' ')

    ax_2.set_title("""Percent Opportunity Youth \n by PUMA in S. King County""" , 
                fontdict = {'fontsize':'48'},
                pad=20)

    divider_2 = make_axes_locatable(ax_2)
    cax_2 = divider_2.append_axes("right", size="5%", pad=0.1)

    geo_df.plot(column = "OY_percent", ax=ax_2, legend = True, cmap = "YlOrBr", cax=cax_2,
                edgecolor ='black')

    plt.savefig("OY_percent_puma_map.png", dpi=200)
    return fig_2, ax_2    
