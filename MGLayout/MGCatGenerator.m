//
//  MGCatGenerator.m
//  MGLayout
//
//  Created by Michael Gray on 8/11/13.
//  Copyright (c) 2013 Michael Gray. All rights reserved.
//

#import "MGCatGenerator.h"
#import "NSMutableArray+RandomShrink.h"

@implementation MGCatGenerator

static NSArray * s_boring_cats;
static NSArray * s_animated_cats;



+ (void) initialize
{
    
    s_boring_cats = @[@"http://25.media.tumblr.com/tumblr_m4on423smR1qzvc2yo1_250.jpg",
                    @"http://29.media.tumblr.com/Jjkybd3nSn75i69zCv2zIivro1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_lg1i99AQfr1qfyzelo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lg7cz6T8YK1qbd47zo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m4iiznoUml1r6jd7fo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m4iieltS5D1qz4dkmo1_250.jpg",
                    @"http://29.media.tumblr.com/tumblr_m3240l7JMB1qberggo1_250.gif",
                    @"http://24.media.tumblr.com/tumblr_m480v9TXec1r63ph3o1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m4u6maLWco1r6b7kmo1_250.jpg",
                    @"http://28.media.tumblr.com/tumblr_lxoi44949k1qzamioo1_250.jpg",
                    @"http://26.media.tumblr.com/tumblr_m38ojtbLsJ1r6b7kmo1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_lr2nrrGGVV1qenqklo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lvv8i4qBY01qzv52ko1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m3e8brOXPL1qejbiro1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m4pvncdREJ1r6jd7fo1_250.jpg",
                    @"http://29.media.tumblr.com/tumblr_lh6zaszadb1qfyzelo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m1mixgpEzz1rp9eteo1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m4cxinsWfd1qze0hyo1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m47ek6a1M81qze0hyo1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_mb8bobaLGI1qejbiro1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m1swbeLP771qa13gio1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m3qkkwho0K1qhwmnpo1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m1b0wcsNSb1qzex9io1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m2lrd13htF1qb8kh2o1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m028xg4NwF1qjahcpo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m4pmd4fx9v1rnc7g6o1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m4pye8pSfL1r6jd7fo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lotzliaGRL1qerv8ko1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_lsk8g3PTuV1qi23vmo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m3ovhuRoyH1r73wdao1_250.gif",
                    @"http://25.media.tumblr.com/tumblr_m3dild5CJw1qzjc9co1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m6xjmdXatN1qjev1to1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lg90gf8N0Q1qfyzelo1_250.jpg",
                    @"http://29.media.tumblr.com/Jjkybd3nSjh8sg2qlpBSHYVqo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lne75tIgdg1qg51mgo1_250.gif",
                    @"http://25.media.tumblr.com/tumblr_m1k5u9MpWB1qg22rso1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_ln7yfxbavb1qdth8zo1_250.jpg",
                    @"http://30.media.tumblr.com/ZabOTt2mpit6yfjwFkqxP4FNo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lupy2qZz2l1r6b7kmo1_250.jpg",
                    @"http://27.media.tumblr.com/tumblr_m32xnaxQ8R1qzex9io1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lzgjv0QudP1qgpr5ko1_250.png",
                    @"http://25.media.tumblr.com/tumblr_m3rf6fukoX1qhmu47o1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m3shf0bz101qau6ygo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_liw4571RiX1qgaj3bo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m1s7gb0Pk51qz5dg8o1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m489879K7h1qddbvio1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_lr2hxgbE5E1qel6s1o1_250.gif",
                    @"http://25.media.tumblr.com/tumblr_lw44j87GMK1r70r72o1_250.jpg",
                    @"http://29.media.tumblr.com/tumblr_lwiagiIzA71qbhms5o1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m40mhklNSd1qzuoq3o1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lsx50eLtwl1r4xjo2o1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m4okzrFJiG1qd477zo1_250.jpg",
                    @"http://24.media.tumblr.com/bzbYyVYjPn255wb6a8WdhDbEo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lm6pohcbba1qdvbl3o1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m4j2q4qXcA1qejbiro1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m3vxk5jAZH1r81frto1_250.jpg",
                    @"http://25.media.tumblr.com/qgIb8tERiqzd4dad8mdzEy9ho1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m27vjmHY8Y1qh66wqo1_250.png",
                    @"http://25.media.tumblr.com/tumblr_m1k9x9eaA51qzex9io1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m24zixuBhR1qanxfwo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_luxl2tCVk41qbe5pxo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m1l2jps0tV1qz4dkmo1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_lyxm5waoQQ1r4c11po1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lozr734hYK1qbhms5o1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m3d8d2DBwl1qddbvio1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_lg1i7dGZ1B1qfyzelo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m3tmjuMfqs1rtuomto1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_ln04n8lPlD1qbt33io1_250.jpg",
                    @"http://29.media.tumblr.com/tumblr_llszoktWkS1qjahcpo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m1lnsx4nE61qz85pko1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m24c42upQM1qabm53o1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m4razlWPhj1qkwytuo1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m8tu6qedAT1rtpgsxo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lqrek5Vb621qajnw8o1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m0tygkqoLj1qbp9xvo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m4evhpaHA61qhwmnpo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lpcqcnJA3s1qbhms5o1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m3y2zsKemH1qe7cdgo1_250.jpg",
                    @"http://25.media.tumblr.com/Jjkybd3nSamse0ejvm86I99x_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lzfz6qs8P71qbe5pxo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_low6sxmuXR1qbhms5o1_250.jpg",
                    @"http://28.media.tumblr.com/tumblr_m3ihwdRdtd1qjimx4o1_250.jpg",
                    @"http://26.media.tumblr.com/tumblr_lyaa9j2Eaw1qa7f1qo1_250.png",
                    @"http://25.media.tumblr.com/Jjkybd3nSaqb3aswN368Nio3_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m22o7wka1Y1qgwbsto1_250.png",
                    @"http://24.media.tumblr.com/tumblr_m2ohy1BLJx1rtmyzjo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m228fsiNxt1qzpypso1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lv12067MQE1qloi1ho1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_ls5hiupcVa1qamec9o1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lysu57Gk831qzx9iho1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_m1k4xjIOIT1qejbiro1_250.jpg",
                    @"http://30.media.tumblr.com/Jjkybd3nSk6ru3o0UYvJC2KYo1_250.jpg",
                    @"http://26.media.tumblr.com/tumblr_m0r6ittt4x1qbhms5o1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_m3s4qsaqBr1qhwmnpo1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_lxlpfhVrGP1r7ryzoo1_250.jpg",
                    @"http://24.media.tumblr.com/tumblr_kohtndaXHT1qzxzwwo1_250.gif",
                    @"http://25.media.tumblr.com/tumblr_m1pdvkP7wR1roj0quo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_lu9qxdTCrA1qdth8zo1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_li263f51ay1qgnva2o1_250.jpg",
                    @"http://25.media.tumblr.com/tumblr_mbrjcm0WNz1qzo3c9o1_250.jpg"];
   
    
    
    
    s_animated_cats = @[@"http://27.media.tumblr.com/tumblr_lkvjl1zBQs1qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_logoono1rB1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lmf5tkeV081qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_ll0z23KRk91qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_lm40emKtR51qjmniro1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_loxxlckQC91qjmniro1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_lluwleqWRn1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_llj16u1XOf1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lmksyrIOe11qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_loio3we5ms1qg6hrko1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lmf653KxBa1qjmniro1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_lluwi7fYCA1qjmniro1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_lkvm1gcvJU1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lkvkztYQWa1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_ll0ytumlrA1qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_lioxjyrvLZ1qcah0do1_r1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_llc81fy5JK1qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_llhz3iC2Ci1qjmniro1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_lmbdexwaua1qjmniro1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_lkxfrcHx8f1qjmniro1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_lkvjgu5GAk1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lmzazaMztT1qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_lkvjj8IIKv1qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_lminpcXmFa1qjmniro1_r1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lms386swQc1qjmniro1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_lkxgupC1mf1qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lognpmebcE1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lmkslx2czx1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_llc7x3Z0sf1qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lli01v5FB31qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_ll18a8PVJd1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lkvjzzf01c1qjmniro1_250.gif",
                        @"http://27.media.tumblr.com/tumblr_lmpu10WHIz1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lmin2uESPK1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_ll2aodLfX91qikh6fo1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_ll0z8d8F681qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lmo5j3aqO41qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lng1vrMhud1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lmktcdksgJ1qjmniro1_250.gif",
                        @"http://27.media.tumblr.com/tumblr_lmnwdxoX4P1qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_ll17fa4WPS1qjmniro1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_lm7my7N7id1qjmniro1_r1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_llhr7moJ2i1qjmniro1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_lla6x7rRjR1qjmniro1_250.gif",
                        @"http://27.media.tumblr.com/tumblr_llj0m6cIBP1qjmniro1_250.gif",
                        @"http://27.media.tumblr.com/tumblr_lng4d4153W1qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lmxkoiR6ow1qjmniro1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_llvpqjbEGY1qzb5qyo1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lm7nj5qzxQ1qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lnpa9h3v7W1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_loxwm8v8fH1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lms248vgxo1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lmu0klDYZ01qjmniro1_250.gif",
                        @"http://27.media.tumblr.com/tumblr_llaiinaeHt1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lnuysmviyZ1qjmniro1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_llq23n45Q61qg20muo1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lmprnwlxwg1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_llc7vhCDYM1qjmniro1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_llrwom0E531qf6xzyo1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_ln1ag2EKLF1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lm41zvd8721qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_llafxpbbJR1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_ll32wtyngh1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lm5th44lXa1qjmniro1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_lmm7rlZWnf1qg20muo1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lmpu7uIW8p1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lmdu84Nxxt1qj9uf7o1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_lnecbtvCRA1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_llahls2IeS1qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lmxkbwXi1n1qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_llair5SATG1qhspilo1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lm7nqykMGu1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_ll7wogQXR91qhspilo1_250.gif",
                        @"http://27.media.tumblr.com/tumblr_llmuxqB4tj1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lo7zh7Og1N1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_llfv4rOohu1qhspilo1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lll2s3W9LN1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lmu047Podq1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_ll0yfthkyo1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lnv0a0Bj4V1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lll2wiiPO61qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lnebm4lgTI1qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lobqsnXKco1qjmniro1_250.gif",
                        @"http://27.media.tumblr.com/tumblr_lkxhavuhiV1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lluwonxXXz1qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lng2cbVsWy1qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_lkxhf4jB1k1qjmniro1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_lmf4f3MnY21qjmniro1_r1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lli04v2zQT1qjmniro1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_lnp9nr8px11qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_lmbpqyFzCo1qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_lmpr1mKbLo1qjmniro1_250.gif",
                        @"http://28.media.tumblr.com/tumblr_ln3333wwtx1qjmniro1_250.gif",
                        @"http://26.media.tumblr.com/tumblr_ln334eM7Dm1qjmniro1_250.gif",
                        @"http://29.media.tumblr.com/tumblr_lmtz0rkweg1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_lmnw7iBTWB1qjmniro1_250.gif",
                        @"http://25.media.tumblr.com/tumblr_lmnw45ZAoQ1qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_llx4uo3ZsF1qjmniro1_250.gif",
                        @"http://24.media.tumblr.com/tumblr_ll2z59NMV21qjmniro1_250.gif",
                        @"http://30.media.tumblr.com/tumblr_llj006tp731qjmniro1_r1_250.gif"];


}


+ (NSURL*) randomAnimatedCatUrl
{
    NSString * catUrlString = [s_animated_cats randomItemFromArray];
    return [NSURL URLWithString:catUrlString];
}

+ (NSURL*) randomBoringCatUrl
{
    NSString * catUrlString = [s_boring_cats randomItemFromArray];
    return [NSURL URLWithString:catUrlString];
}

+ (NSURL*) randomCatUrl
{
    if (arc4random() % 2) {
        return [self randomBoringCatUrl];
    }
    else {
        return [self randomAnimatedCatUrl];
    }
}



@end
