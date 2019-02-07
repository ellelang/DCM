#######################################
#
# File: 01simpleIntegral.py
# Author: Michel Bierlaire, EPFL
# Date: Sat Jul 25 11:41:13 2015
#
#######################################

from biogeme import *

from headers import *

import biogeme.expressions as expr
import biogeme.biogeme as bio



bio.BIOGEME._generateDraws
i
integrand = exp(bioDraws('U',1))
simulatedI = MonteCarlo(integrand)

trueI = exp(1.0) - 1.0 

sampleVariance = \
  MonteCarlo(integrand*integrand) - simulatedI * simulatedI
stderr = (sampleVariance / 200000.0)**0.5
error = simulatedI - trueI

simulate = {'01 Simulated Integral': simulatedI,
            '02 Analytical Integral': trueI,
            '03 Sample variance': sampleVariance,
            '04 Std Error': stderr,
            '05 Error': error}

draw.rowIterator('obsIter') 
expressions.Enumerate(simulate,'obsIter')

bio.BIOGEME_OBJECT.SIMULATE = 1
BIOGEME_OBJECT.PARAMETERS['NbrOfDraws'] = "200000"
BIOGEME_OBJECT.PARAMETERS['RandomDistribution'] = "PSEUDO"
__rowId__ = Variable('__rowId__')
BIOGEME_OBJECT.EXCLUDE = __rowId__ >= 1
BIOGEME_OBJECT.DRAWS = { 'U': 'UNIFORM'}
