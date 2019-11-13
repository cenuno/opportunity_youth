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