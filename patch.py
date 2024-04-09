@@ -288,7 +288,7 @@ def __init__(self, name, level, pathname, lineno,
         """
         Initialize a logging record with interesting information.
         """
-        ct = time.time()
+        ct = time.time_ns()
         self.name = name
         self.msg = msg
         #
@@ -327,8 +327,9 @@ def __init__(self, name, level, pathname, lineno,
         self.stack_info = sinfo
         self.lineno = lineno
         self.funcName = func
-        self.created = ct
-        self.msecs = (ct - int(ct)) * 1000
+        self.created = ct / 1000_000_000
+        self.msecs = (ct // 1000_000) % 1000
+        self.usecs = (ct // 1000) % 1000
         self.relativeCreated = (self.created - _startTime) * 1000
         if logThreads:
             self.thread = threading.get_ident()
@@ -555,6 +556,7 @@ class Formatter(object):
                         return value)
     %(asctime)s         Textual time when the LogRecord was created
     %(msecs)d           Millisecond portion of the creation time
+    %(usecs)d           Microsecond portion of the creation time
     %(relativeCreated)d Time in milliseconds when the LogRecord was created,
                         relative to the time the logging module was loaded
                         (typically at application startup time)

