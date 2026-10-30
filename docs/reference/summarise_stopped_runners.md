# Summarise Backyard Ultra Runner Performance

Summarises the performance of stopped runners from the 2026 Backyard
Ultra World Team Championships. Results can be grouped by nation or
competition class.

## Usage

``` r
summarise_stopped_runners(data = wtc_stopped, group = "nation", min_yards = 0)
```

## Arguments

- data:

  A data frame containing runner information. Defaults to `wtc_stopped`.

- group:

  Variable used to group results. Either "nation" or "class".

- min_yards:

  Minimum number of completed yards required for a runner to be
  included.

## Value

A data frame containing the group, runner count, mean yards, median
yards, maximum yards and total yards.

## Examples

``` r
summarise_stopped_runners(group = "nation")
#>                       group runners mean_yards median_yards max_yards
#> 1  United States of America      14   72.35714         78.5       106
#> 2                 Australia      14   70.14286         73.0        86
#> 3                   Belgium      15   70.53333         64.0       124
#> 4                     Japan      14   66.64286         63.0       104
#> 5                    France      14   56.28571         60.0       100
#> 6            United Kingdom      14   60.64286         58.0        89
#> 7                    Poland      14   54.07143         56.0        82
#> 8               New Zealand      14   54.07143         52.0        76
#> 9                       AIN      13   50.07692         51.0        80
#> 10                   Canada      14   53.42857         49.5        81
#> 11                   Sweden      14   43.42857         44.0        57
#> 12                   Norway      14   43.92857         39.5        72
#> 13                   Mexico      14   42.14286         39.0        72
#> 14                  Germany      14   39.35714         38.5        68
#> 15                  Hungary      14   40.71429         38.0        62
#> 16                  Austria      14   39.50000         37.0        51
#> 17              Netherlands      14   39.57143         37.0        62
#> 18                    Italy      14   37.78571         35.5        54
#> 19                Argentina      14   35.28571         35.0        50
#> 20                Lithuania      14   33.85714         34.5        48
#> 21                 Portugal      13   31.76923         34.0        48
#> 22                  Denmark      14   36.78571         33.0        59
#> 23                  Finland      14   33.78571         33.0        51
#> 24                   Latvia      14   33.07143         33.0        42
#> 25                  Czechia      14   30.50000         32.5        40
#> 26                  Iceland      14   35.00000         32.5        68
#> 27                  Ireland      14   31.57143         32.0        38
#> 28                  Romania      14   32.64286         31.0        61
#> 29                 Slovakia      14   28.14286         30.5        36
#> 30                   Greece      14   28.92857         30.0        42
#> 31                   Israel      14   31.71429         30.0        47
#> 32                    Kenya      11   29.27273         30.0        38
#> 33              Switzerland      14   29.21429         29.0        42
#> 34                   Brazil      14   30.64286         28.5        51
#> 35                  Estonia      14   26.50000         28.5        40
#> 36                 Slovenia      14   27.92857         28.5        41
#> 37                Venezuela      14   28.28571         28.0        39
#> 38             South Africa      14   29.21429         27.5        40
#> 39                  Algeria      14   25.21429         26.5        35
#> 40                 Colombia      13   27.61538         25.0        40
#> 41                Guatemala      14   27.07143         25.0        42
#> 42                    Malta      14   23.57143         24.0        33
#> 43              Philippines      14   26.35714         24.0        47
#> 44                    Spain      15   23.86667         24.0        24
#> 45                   Turkey      13   26.00000         24.0        48
#> 46                  Ukraine      14   22.28571         24.0        37
#> 47                  Bolivia      14   24.92857         23.5        39
#> 48                    Chile      14   22.00000         23.0        37
#> 49                    India      14   25.14286         23.0        44
#> 50                  Uruguay      14   22.64286         21.0        38
#> 51                   Taipei      14   20.00000         20.5        28
#> 52                 Paraguay      14   20.85714         20.0        30
#> 53                  Namibia      14   17.92857         18.5        22
#> 54               Costa Rica      14   17.50000         18.0        24
#> 55                   Zambia      14   17.50000         18.0        31
#> 56       Dominican Republic      14   16.21429         17.5        25
#> 57                  Ecuador      11   16.27273         17.0        26
#> 58                  Morocco      14   20.28571         17.0        46
#> 59                   Brunei      14   15.85714         16.0        26
#> 60            Côte d'Ivoire      14   17.71429         16.0        35
#> 61                    Nepal      12   16.91667         16.0        26
#> 62                 Pakistan      14   14.64286         16.0        28
#> 63                 Bulgaria      13   15.23077         14.0        33
#> 64                     Cuba      14   14.07143         14.0        24
#> 65                 Malaysia      12   13.33333         14.0        20
#> 66                  Bermuda      14   12.71429         12.0        24
#> 67               Tajikistan      14   11.78571         10.5        24
#>    total_yards
#> 1         1013
#> 2          982
#> 3         1058
#> 4          933
#> 5          788
#> 6          849
#> 7          757
#> 8          757
#> 9          651
#> 10         748
#> 11         608
#> 12         615
#> 13         590
#> 14         551
#> 15         570
#> 16         553
#> 17         554
#> 18         529
#> 19         494
#> 20         474
#> 21         413
#> 22         515
#> 23         473
#> 24         463
#> 25         427
#> 26         490
#> 27         442
#> 28         457
#> 29         394
#> 30         405
#> 31         444
#> 32         322
#> 33         409
#> 34         429
#> 35         371
#> 36         391
#> 37         396
#> 38         409
#> 39         353
#> 40         359
#> 41         379
#> 42         330
#> 43         369
#> 44         358
#> 45         338
#> 46         312
#> 47         349
#> 48         308
#> 49         352
#> 50         317
#> 51         280
#> 52         292
#> 53         251
#> 54         245
#> 55         245
#> 56         227
#> 57         179
#> 58         284
#> 59         222
#> 60         248
#> 61         203
#> 62         205
#> 63         198
#> 64         197
#> 65         160
#> 66         178
#> 67         165
summarise_stopped_runners(group = "class")
#>       group runners mean_yards median_yards max_yards total_yards
#> 1 Super Six      84   64.58333         62.5       124        5425
#> 2 Class AAA     252   40.85317         38.0        89       10295
#> 3  Class AA     278   28.85612         29.0        61        8022
#> 4   Class A     311   18.92283         18.0        42        5885
summarise_stopped_runners(group = "nation", min_yards = 50)
#>                       group runners mean_yards median_yards max_yards
#> 1  United States of America      11   79.81818         83.0       106
#> 2                 Australia      13   72.46154         73.0        86
#> 3                    Mexico       2   70.50000         70.5        72
#> 4            United Kingdom      10   68.70000         69.0        89
#> 5               New Zealand       8   65.12500         67.5        76
#> 6                   Belgium      13   74.69231         67.0       124
#> 7                    Norway       5   64.80000         67.0        72
#> 8                    Poland       8   66.62500         67.0        82
#> 9                   Iceland       2   65.50000         65.5        68
#> 10                  Germany       3   63.33333         65.0        68
#> 11                   Canada       7   66.28571         64.0        81
#> 12                   France      10   66.30000         63.5       100
#> 13                    Japan      14   66.64286         63.0       104
#> 14              Netherlands       2   61.50000         61.5        62
#> 15                  Romania       1   61.00000         61.0        61
#> 16                      AIN       7   59.42857         57.0        80
#> 17                  Hungary       2   56.00000         56.0        62
#> 18                    Italy       1   54.00000         54.0        54
#> 19                   Brazil       2   51.00000         51.0        51
#> 20                  Finland       1   51.00000         51.0        51
#> 21                  Austria       2   50.50000         50.5        51
#> 22                Argentina       1   50.00000         50.0        50
#> 23                  Denmark       5   53.40000         50.0        59
#> 24                   Sweden       5   52.00000         50.0        57
#>    total_yards
#> 1          878
#> 2          942
#> 3          141
#> 4          687
#> 5          521
#> 6          971
#> 7          324
#> 8          533
#> 9          131
#> 10         190
#> 11         464
#> 12         663
#> 13         933
#> 14         123
#> 15          61
#> 16         416
#> 17         112
#> 18          54
#> 19         102
#> 20          51
#> 21         101
#> 22          50
#> 23         267
#> 24         260
```
