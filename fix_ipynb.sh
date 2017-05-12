#!/bin/sh
#
# Author: Graham Williams
# Date: 20170111
#
# This is not done by notedown but it is what is on the end of a
# sample notebook so add it here and the document kernel is recognised
# as R.

perl -pi -e 's|"metadata": \{\},| "metadata": {\
  "anaconda-cloud": {},\
  "kernelspec": {\
   "display_name": "R",\
   "language": "R",\
   "name": "ir"\
  },\
  "language_info": {\
   "codemirror_mode": "r",\
   "file_extension": ".r",\
   "mimetype": "text/x-r-source",\
   "name": "R",\
   "pygments_lexer": "r",\
   "version": "3.2.2"\
  }\
 },|' $1
