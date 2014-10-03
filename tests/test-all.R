## Run the tests if the system variable 'R_CHECK_TESTS' is set to TRUE

flag <- as.logical(Sys.getenv('R_CHECK_TESTS'))
if(!is.na(flag)) {
    if(flag == TRUE) {
        library('testthat')
        test_check('derfinderPlot')
    }
} else {
    message('Set the system variable R_CHECK_TESTS to TRUE to run all the tests.')
}
