# Overall (98/100)
 - Sorry for blowing up the pretty formatting, trying to make it easier to
   add the pdf comments - nonetheless, the journal formatting is a nice touch
   as well as the inclusion of the abstract

# Build (10/10)
 - Excellent attention paid to the build instructions
 - Nice incorporation of environment components in build script (should list
   that it depends on a specific package manager though!)
 - The binder badge is a nice touch! (though the ref seems broken)
 - Note that you need not implement the hashing yourself as you did in 
   your validation script, check out `md5sum -c` (though this assumes you are
   running on a system with standard checksum utils available)
 - You just HAD to use f-strings didn't you... not everyone has 3.6! (jk, of
   course you're not wrong for using the must modern python)

# Testing (10/10)
 - Well-designed tests

# Introduction / Motivation / Background (15/15)
 - Nice abstract
 - Excellent overview of relevant topics
 - Appropriate level of detail and background provided to contextualize the
   work

# Methods (15/15)
 - Good decomposition of the task at hand into sub-tasks, e.g. pulse height
   spectra formation, centroid determination and parameter optimization
 - Excellent amount of detail in covering the different components of your
   analysis

# Results and Discussion (38/40)
 - Good figures, well labeled/captioned, and convey relevant information
 - Nice discussion on generalizing approach to higher-order models - discussion
   of this nature is of the correct scope for NE204
 - A bit more focus on uncertainty, both of centroid estimation and propagation
   through to the linear model would be appropriate

# Conclusion (10/10)
 - No explicit conclusion section required, the discussion is thorough
