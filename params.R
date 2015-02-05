set.seed(1911)

outcomes <- c('NonfatalMI', 'NonfatalStroke', 'All-causeMortality',
              'Myalgia', 'Transaminase', 'CK')

oc.names <- list('NonfatalMI'='Nonfatal MI',
                 'NonfatalStroke'='Nonfatal Stroke',
                 'All-causeMortality'='All-cause Mortality',
                 'Discontinuations'='Discontinuations',
                 'Myalgia'='Myalgia',
                 'Transaminase'='Transaminase',
                 'CK'='CK Elevation')

outcomes.use.single.trial <- c('NonfatalMI', 'NonfatalStroke', 'All-causeMortality')

treatments <- c('Control', 'Atorva', 'Fluva', 'Lova', 'Prava', 'Rosuva', 'Simva')
