diff --git a/include/boost/python/numpy/config.hpp b/include/boost/python/numpy/config.hpp
index 6f39d3c..9717890 100644
--- a/include/boost/python/numpy/config.hpp
+++ b/include/boost/python/numpy/config.hpp
@@ -62,7 +62,11 @@
 // Set the name of our library, this will get undef'ed by auto_link.hpp
 // once it's done with it:
 //
-#define BOOST_LIB_NAME boost_numpy
+#if PY_MAJOR_VERSION == 2
+#  define BOOST_LIB_NAME boost_numpy
+#elif PY_MAJOR_VERSION == 3
+#  define BOOST_LIB_NAME boost_numpy3
+#endif
 //
 // If we're importing code from a dll, then tell auto_link.hpp about it:
 //
@@ -75,4 +79,6 @@
 #include <boost/config/auto_link.hpp>
 #endif  // auto-linking disabled
 
+#define NPY_NO_DEPRECATED_API NPY_1_7_API_VERSION
+
 #endif // CONFIG_NUMPY20170215_H_
