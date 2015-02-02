set.seed(1911)

outcomes <- c('NonfatalMI', 'NonfatalStroke', 'All-causeMortality',
              'Discontinuations', 'Myalgia', 'Transaminase',
              'CK')

outcomes.use.single.trial <- c('NonfatalMI', 'NonfatalStroke', 'All-causeMortality')

treatments <- c('Control', 'Atorva', 'Fluva', 'Lova', 'Prava', 'Rosuva', 'Simva')
