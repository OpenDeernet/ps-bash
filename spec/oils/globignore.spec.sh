## Imported from the Oils spec tests (globignore.test.sh, Apache-2.0, https://github.com/oils-for-unix/oils).
## Names and scripts only; expectations are recorded from bash 5.2, not taken from Oils.
## Cases using the Oils harness ($SH, $REPO_ROOT, ...) are omitted.
#### Don't glob flags on file system with GLOBIGNORE
touch _tmp/-n _tmp/zzzzz
cd _tmp
GLOBIGNORE=-*:zzzzz  # colon-separated pattern list
echo -* hello zzzz?
## stdout: -* hello zzzz?
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Ignore *.txt
touch one.md one.txt
mkdir -p foo
touch foo/{two.md,two.txt}
GLOBIGNORE=*.txt
echo *.* foo/*.*
## stdout: .msCoverageSourceRootsMapping_PsBash.Spec.Tests Microsoft.TestPlatform.CommunicationUtilities.dll Microsoft.TestPlatform.CoreUtilities.dll Microsoft.TestPlatform.CrossPlatEngine.dll Microsoft.TestPlatform.PlatformAbstractions.dll Microsoft.TestPlatform.Utilities.dll Microsoft.VisualStudio.CodeCoverage.Shim.dll Microsoft.VisualStudio.TestPlatform.Common.dll Microsoft.VisualStudio.TestPlatform.ObjectModel.dll Newtonsoft.Json.dll Parlot.dll PsBash.Core.dll PsBash.Core.pdb PsBash.Core.xml PsBash.Spec.Tests.deps.json PsBash.Spec.Tests.dll PsBash.Spec.Tests.pdb PsBash.Spec.Tests.runtimeconfig.json PsBash.Spec.dll PsBash.Spec.pdb PsBash.Testing.dll PsBash.Testing.pdb PsBash.Transpiler.dll PsBash.Transpiler.pdb PsBash.Transpiler.xml bar.cc bar.h baz.h foo. foo.cc foo.h foo.hh hello.c hello.h hello.o leaf.md one.md ps-bash-host.deps.json ps-bash-host.exe ps-bash-host.runtimeconfig.json ps-bash.deps.json ps-bash.exe ps-bash.runtimeconfig.json testhost.dll testhost.exe xunit.abstractions.dll xunit.assert.dll xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json xunit.runner.reporters.netcoreapp10.dll xunit.runner.utility.netcoreapp10.dll xunit.runner.visualstudio.testadapter.dll y.Y yy.Y foo/*.*
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Ignore ?.txt
touch {1,10}.txt
mkdir -p foo
touch foo/{2,20}.txt
GLOBIGNORE=?.txt
echo *.* foo/*.*
## stdout: .msCoverageSourceRootsMapping_PsBash.Spec.Tests 10.txt Microsoft.TestPlatform.CommunicationUtilities.dll Microsoft.TestPlatform.CoreUtilities.dll Microsoft.TestPlatform.CrossPlatEngine.dll Microsoft.TestPlatform.PlatformAbstractions.dll Microsoft.TestPlatform.Utilities.dll Microsoft.VisualStudio.CodeCoverage.Shim.dll Microsoft.VisualStudio.TestPlatform.Common.dll Microsoft.VisualStudio.TestPlatform.ObjectModel.dll Newtonsoft.Json.dll Parlot.dll PsBash.Core.dll PsBash.Core.pdb PsBash.Core.xml PsBash.Spec.Tests.deps.json PsBash.Spec.Tests.dll PsBash.Spec.Tests.pdb PsBash.Spec.Tests.runtimeconfig.json PsBash.Spec.dll PsBash.Spec.pdb PsBash.Testing.dll PsBash.Testing.pdb PsBash.Transpiler.dll PsBash.Transpiler.pdb PsBash.Transpiler.xml bar.cc bar.h bar.txt baz.h err.txt foo. foo.cc foo.h foo.hh foo.txt hello.c hello.h hello.o hi.txt leaf.md one.md one.txt process-sub.txt ps-bash-host.deps.json ps-bash-host.exe ps-bash-host.runtimeconfig.json ps-bash.deps.json ps-bash.exe ps-bash.runtimeconfig.json smoke1.txt testhost.dll testhost.exe tmp.txt traps.txt xunit.abstractions.dll xunit.assert.dll xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json xunit.runner.reporters.netcoreapp10.dll xunit.runner.utility.netcoreapp10.dll xunit.runner.visualstudio.testadapter.dll y.Y yy.Y foo/*.*
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Ignore *.o:*.h
touch {hello.c,hello.h,hello.o,hello}
GLOBIGNORE=*.o:*.h
echo hello*
## stdout: hello hello.c
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Ignore single file src/__main__.py
mkdir src
touch src/{__init__.py,__main__.py}
GLOBIGNORE='src/__init__.py'
echo src/*
## stdout: src/__main__.py
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Ignore dirs dist/*:node_modules/*
mkdir {src,compose,dist,node_modules}
touch src/{a.js,b.js}
touch compose/{base.compose.yaml,dev.compose.yaml}
touch dist/index.js
touch node_modules/package.js
GLOBIGNORE=dist/*:node_modules/*
echo */*
## stdout: 0/bar.cc 0/bar.h 0/baz.h 0/foo.cc 0/foo.h 2/aa 2/ab 2/ac 2/ba 2/bb 2/bc 2/ca 2/cb 2/cc 3/bar.cc 3/bar.h _failglob/foo _tmp/"quoted.py" _tmp/? _tmp/[abc] _tmp/foo.zzz _tmp/notbin _tmp/posix-compound.txt _tmp/zzzzz c/leaf.md c/subdir compose/base.compose.yaml compose/dev.compose.yaml cs/Microsoft.TestPlatform.CommunicationUtilities.resources.dll cs/Microsoft.TestPlatform.CoreUtilities.resources.dll cs/Microsoft.TestPlatform.CrossPlatEngine.resources.dll cs/Microsoft.VisualStudio.TestPlatform.Common.resources.dll cs/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll de/Microsoft.TestPlatform.CommunicationUtilities.resources.dll de/Microsoft.TestPlatform.CoreUtilities.resources.dll de/Microsoft.TestPlatform.CrossPlatEngine.resources.dll de/Microsoft.VisualStudio.TestPlatform.Common.resources.dll de/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll dir1/a.txt dir1/ignore.txt dir2/a.txt dir2/ignore.txt directory/leaf.md eg1/_ eg1/_One eg1/_OneOne eg1/_OneTwo eg1/_TwoTwo eg10/a b c.cc eg10/a b c.py eg10/bee.cc eg10/bee.py eg10/cee.cc eg10/cee.py eg11/bar.py eg11/foo.py eg11/spam.py eg2/_ eg2/_One eg2/_OneOne eg2/_OneTwo eg2/_TwoTwo eg4/a eg4/a b eg4/foo eg5/'a b'cd eg5/'a b'de eg5/'a b'ef eg5/__# eg5/__&& eg5/__<> eg5/__aa eg5/__{} eg5/a bcd eg5/a bde eg5/a bef eg6/ab eg6/ac eg6/ad eg6/az eg6/bc eg6/bd eg7/_* eg7/_? eg7/_[ eg7/_[:] eg8/bar.py eg8/foo.py eg8/spam.py eg9/bar.py eg9/foo.py es/Microsoft.TestPlatform.CommunicationUtilities.resources.dll es/Microsoft.TestPlatform.CoreUtilities.resources.dll es/Microsoft.TestPlatform.CrossPlatEngine.resources.dll es/Microsoft.VisualStudio.TestPlatform.Common.resources.dll es/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll extglob2/bar.cc extglob2/bar.h extglob2/bar.py extglob2/baz.h extglob2/baz.py extglob2/foo.cc extglob2/foo.h extglob2/foo.py extpipe/__| extpipe/foo fr/Microsoft.TestPlatform.CommunicationUtilities.resources.dll fr/Microsoft.TestPlatform.CoreUtilities.resources.dll fr/Microsoft.TestPlatform.CrossPlatEngine.resources.dll fr/Microsoft.VisualStudio.TestPlatform.Common.resources.dll fr/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll it/Microsoft.TestPlatform.CommunicationUtilities.resources.dll it/Microsoft.TestPlatform.CoreUtilities.resources.dll it/Microsoft.TestPlatform.CrossPlatEngine.resources.dll it/Microsoft.VisualStudio.TestPlatform.Common.resources.dll it/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll ja/Microsoft.TestPlatform.CommunicationUtilities.resources.dll ja/Microsoft.TestPlatform.CoreUtilities.resources.dll ja/Microsoft.TestPlatform.CrossPlatEngine.resources.dll ja/Microsoft.VisualStudio.TestPlatform.Common.resources.dll ja/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll ko/Microsoft.TestPlatform.CommunicationUtilities.resources.dll ko/Microsoft.TestPlatform.CoreUtilities.resources.dll ko/Microsoft.TestPlatform.CrossPlatEngine.resources.dll ko/Microsoft.VisualStudio.TestPlatform.Common.resources.dll ko/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll one/mycmd opts/-dash opts/bar opts/foo pl/Microsoft.TestPlatform.CommunicationUtilities.resources.dll pl/Microsoft.TestPlatform.CoreUtilities.resources.dll pl/Microsoft.TestPlatform.CrossPlatEngine.resources.dll pl/Microsoft.VisualStudio.TestPlatform.Common.resources.dll pl/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll pt-BR/Microsoft.TestPlatform.CommunicationUtilities.resources.dll pt-BR/Microsoft.TestPlatform.CoreUtilities.resources.dll pt-BR/Microsoft.TestPlatform.CrossPlatEngine.resources.dll pt-BR/Microsoft.VisualStudio.TestPlatform.Common.resources.dll pt-BR/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll ref/Microsoft.CSharp.dll ref/Microsoft.VisualBasic.Core.dll ref/Microsoft.VisualBasic.dll ref/Microsoft.Win32.Primitives.dll ref/Microsoft.Win32.Registry.dll ref/System.AppContext.dll ref/System.Buffers.dll ref/System.Collections.Concurrent.dll ref/System.Collections.Immutable.dll ref/System.Collections.NonGeneric.dll ref/System.Collections.Specialized.dll ref/System.Collections.dll ref/System.ComponentModel.Annotations.dll ref/System.ComponentModel.DataAnnotations.dll ref/System.ComponentModel.EventBasedAsync.dll ref/System.ComponentModel.Primitives.dll ref/System.ComponentModel.TypeConverter.dll ref/System.ComponentModel.dll ref/System.Configuration.dll ref/System.Console.dll ref/System.Core.dll ref/System.Data.Common.dll ref/System.Data.DataSetExtensions.dll ref/System.Data.dll ref/System.Diagnostics.Contracts.dll ref/System.Diagnostics.Debug.dll ref/System.Diagnostics.DiagnosticSource.dll ref/System.Diagnostics.FileVersionInfo.dll ref/System.Diagnostics.Process.dll ref/System.Diagnostics.StackTrace.dll ref/System.Diagnostics.TextWriterTraceListener.dll ref/System.Diagnostics.Tools.dll ref/System.Diagnostics.TraceSource.dll ref/System.Diagnostics.Tracing.dll ref/System.Drawing.Primitives.dll ref/System.Drawing.dll ref/System.Dynamic.Runtime.dll ref/System.Formats.Asn1.dll ref/System.Formats.Tar.dll ref/System.Globalization.Calendars.dll ref/System.Globalization.Extensions.dll ref/System.Globalization.dll ref/System.IO.Compression.Brotli.dll ref/System.IO.Compression.FileSystem.dll ref/System.IO.Compression.ZipFile.dll ref/System.IO.Compression.dll ref/System.IO.FileSystem.AccessControl.dll ref/System.IO.FileSystem.DriveInfo.dll ref/System.IO.FileSystem.Primitives.dll ref/System.IO.FileSystem.Watcher.dll ref/System.IO.FileSystem.dll ref/System.IO.IsolatedStorage.dll ref/System.IO.MemoryMappedFiles.dll ref/System.IO.Pipes.AccessControl.dll ref/System.IO.Pipes.dll ref/System.IO.UnmanagedMemoryStream.dll ref/System.IO.dll ref/System.Linq.Expressions.dll ref/System.Linq.Parallel.dll ref/System.Linq.Queryable.dll ref/System.Linq.dll ref/System.Memory.dll ref/System.Net.Http.Json.dll ref/System.Net.Http.dll ref/System.Net.HttpListener.dll ref/System.Net.Mail.dll ref/System.Net.NameResolution.dll ref/System.Net.NetworkInformation.dll ref/System.Net.Ping.dll ref/System.Net.Primitives.dll ref/System.Net.Quic.dll ref/System.Net.Requests.dll ref/System.Net.Security.dll ref/System.Net.ServicePoint.dll ref/System.Net.Sockets.dll ref/System.Net.WebClient.dll ref/System.Net.WebHeaderCollection.dll ref/System.Net.WebProxy.dll ref/System.Net.WebSockets.Client.dll ref/System.Net.WebSockets.dll ref/System.Net.dll ref/System.Numerics.Vectors.dll ref/System.Numerics.dll ref/System.ObjectModel.dll ref/System.Reflection.DispatchProxy.dll ref/System.Reflection.Emit.ILGeneration.dll ref/System.Reflection.Emit.Lightweight.dll ref/System.Reflection.Emit.dll ref/System.Reflection.Extensions.dll ref/System.Reflection.Metadata.dll ref/System.Reflection.Primitives.dll ref/System.Reflection.TypeExtensions.dll ref/System.Reflection.dll ref/System.Resources.Reader.dll ref/System.Resources.ResourceManager.dll ref/System.Resources.Writer.dll ref/System.Runtime.CompilerServices.Unsafe.dll ref/System.Runtime.CompilerServices.VisualC.dll ref/System.Runtime.Extensions.dll ref/System.Runtime.Handles.dll ref/System.Runtime.InteropServices.JavaScript.dll ref/System.Runtime.InteropServices.RuntimeInformation.dll ref/System.Runtime.InteropServices.dll ref/System.Runtime.Intrinsics.dll ref/System.Runtime.Loader.dll ref/System.Runtime.Numerics.dll ref/System.Runtime.Serialization.Formatters.dll ref/System.Runtime.Serialization.Json.dll ref/System.Runtime.Serialization.Primitives.dll ref/System.Runtime.Serialization.Xml.dll ref/System.Runtime.Serialization.dll ref/System.Runtime.dll ref/System.Security.AccessControl.dll ref/System.Security.Claims.dll ref/System.Security.Cryptography.Algorithms.dll ref/System.Security.Cryptography.Cng.dll ref/System.Security.Cryptography.Csp.dll ref/System.Security.Cryptography.Encoding.dll ref/System.Security.Cryptography.OpenSsl.dll ref/System.Security.Cryptography.Primitives.dll ref/System.Security.Cryptography.X509Certificates.dll ref/System.Security.Cryptography.dll ref/System.Security.Principal.Windows.dll ref/System.Security.Principal.dll ref/System.Security.SecureString.dll ref/System.Security.dll ref/System.ServiceModel.Web.dll ref/System.ServiceProcess.dll ref/System.Text.Encoding.CodePages.dll ref/System.Text.Encoding.Extensions.dll ref/System.Text.Encoding.dll ref/System.Text.Encodings.Web.dll ref/System.Text.Json.dll ref/System.Text.RegularExpressions.dll ref/System.Threading.Channels.dll ref/System.Threading.Overlapped.dll ref/System.Threading.Tasks.Dataflow.dll ref/System.Threading.Tasks.Extensions.dll ref/System.Threading.Tasks.Parallel.dll ref/System.Threading.Tasks.dll ref/System.Threading.Thread.dll ref/System.Threading.ThreadPool.dll ref/System.Threading.Timer.dll ref/System.Threading.dll ref/System.Transactions.Local.dll ref/System.Transactions.dll ref/System.ValueTuple.dll ref/System.Web.HttpUtility.dll ref/System.Web.dll ref/System.Windows.dll ref/System.Xml.Linq.dll ref/System.Xml.ReaderWriter.dll ref/System.Xml.Serialization.dll ref/System.Xml.XDocument.dll ref/System.Xml.XPath.XDocument.dll ref/System.Xml.XPath.dll ref/System.Xml.XmlDocument.dll ref/System.Xml.XmlSerializer.dll ref/System.Xml.dll ref/System.dll ref/WindowsBase.dll ref/mscorlib.dll ref/netstandard.dll ru/Microsoft.TestPlatform.CommunicationUtilities.resources.dll ru/Microsoft.TestPlatform.CoreUtilities.resources.dll ru/Microsoft.TestPlatform.CrossPlatEngine.resources.dll ru/Microsoft.VisualStudio.TestPlatform.Common.resources.dll ru/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll runtimes/unix runtimes/win src/__init__.py src/__main__.py src/a.js src/b.js tr/Microsoft.TestPlatform.CommunicationUtilities.resources.dll tr/Microsoft.TestPlatform.CoreUtilities.resources.dll tr/Microsoft.TestPlatform.CrossPlatEngine.resources.dll tr/Microsoft.VisualStudio.TestPlatform.Common.resources.dll tr/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll two/mycmd x/test.ifs.'.txt x/test.ifs.*.txt x/test.ifs.\.txt x/test.ifs.\b.txt x/test.ifs.a.txt zh-Hans/Microsoft.TestPlatform.CommunicationUtilities.resources.dll zh-Hans/Microsoft.TestPlatform.CoreUtilities.resources.dll zh-Hans/Microsoft.TestPlatform.CrossPlatEngine.resources.dll zh-Hans/Microsoft.VisualStudio.TestPlatform.Common.resources.dll zh-Hans/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll zh-Hant/Microsoft.TestPlatform.CommunicationUtilities.resources.dll zh-Hant/Microsoft.TestPlatform.CoreUtilities.resources.dll zh-Hant/Microsoft.TestPlatform.CrossPlatEngine.resources.dll zh-Hant/Microsoft.VisualStudio.TestPlatform.Common.resources.dll zh-Hant/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### find files in subdirectory but not the ignored pattern
mkdir {dir1,dir2}
touch dir1/{a.txt,ignore.txt}
touch dir2/{a.txt,ignore.txt}
GLOBIGNORE=*/ignore*
echo */*
## stdout: 0/bar.cc 0/bar.h 0/baz.h 0/foo.cc 0/foo.h 2/aa 2/ab 2/ac 2/ba 2/bb 2/bc 2/ca 2/cb 2/cc 3/bar.cc 3/bar.h _failglob/foo _tmp/"quoted.py" _tmp/? _tmp/[abc] _tmp/dir _tmp/e.E _tmp/ex _tmp/file _tmp/foo.- _tmp/foo.yyy _tmp/foo.zzz _tmp/notbin _tmp/posix-compound.txt _tmp/zzzzz c/leaf.md c/subdir compose/base.compose.yaml compose/dev.compose.yaml cs/Microsoft.TestPlatform.CommunicationUtilities.resources.dll cs/Microsoft.TestPlatform.CoreUtilities.resources.dll cs/Microsoft.TestPlatform.CrossPlatEngine.resources.dll cs/Microsoft.VisualStudio.TestPlatform.Common.resources.dll cs/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll de/Microsoft.TestPlatform.CommunicationUtilities.resources.dll de/Microsoft.TestPlatform.CoreUtilities.resources.dll de/Microsoft.TestPlatform.CrossPlatEngine.resources.dll de/Microsoft.VisualStudio.TestPlatform.Common.resources.dll de/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll dir1/a.txt dir2/a.txt directory/leaf.md dist/index.js eg1/_ eg1/_One eg1/_OneOne eg1/_OneTwo eg1/_TwoTwo eg10/a b c.cc eg10/a b c.py eg10/bee.cc eg10/bee.py eg10/cee.cc eg10/cee.py eg11/bar.py eg11/foo.py eg11/spam.py eg2/_ eg2/_One eg2/_OneOne eg2/_OneTwo eg2/_TwoTwo eg4/a eg4/a b eg4/foo eg5/'a b'cd eg5/'a b'de eg5/'a b'ef eg5/__# eg5/__&& eg5/__<> eg5/__aa eg5/__{} eg5/a bcd eg5/a bde eg5/a bef eg6/ab eg6/ac eg6/ad eg6/az eg6/bc eg6/bd eg7/_* eg7/_? eg7/_[ eg7/_[:] eg8/bar.py eg8/foo.py eg8/spam.py eg9/bar.py eg9/foo.py es/Microsoft.TestPlatform.CommunicationUtilities.resources.dll es/Microsoft.TestPlatform.CoreUtilities.resources.dll es/Microsoft.TestPlatform.CrossPlatEngine.resources.dll es/Microsoft.VisualStudio.TestPlatform.Common.resources.dll es/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll extglob2/bar.cc extglob2/bar.h extglob2/bar.py extglob2/baz.h extglob2/baz.py extglob2/foo.cc extglob2/foo.h extglob2/foo.py extpipe/__| extpipe/foo fr/Microsoft.TestPlatform.CommunicationUtilities.resources.dll fr/Microsoft.TestPlatform.CoreUtilities.resources.dll fr/Microsoft.TestPlatform.CrossPlatEngine.resources.dll fr/Microsoft.VisualStudio.TestPlatform.Common.resources.dll fr/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll it/Microsoft.TestPlatform.CommunicationUtilities.resources.dll it/Microsoft.TestPlatform.CoreUtilities.resources.dll it/Microsoft.TestPlatform.CrossPlatEngine.resources.dll it/Microsoft.VisualStudio.TestPlatform.Common.resources.dll it/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll ja/Microsoft.TestPlatform.CommunicationUtilities.resources.dll ja/Microsoft.TestPlatform.CoreUtilities.resources.dll ja/Microsoft.TestPlatform.CrossPlatEngine.resources.dll ja/Microsoft.VisualStudio.TestPlatform.Common.resources.dll ja/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll ko/Microsoft.TestPlatform.CommunicationUtilities.resources.dll ko/Microsoft.TestPlatform.CoreUtilities.resources.dll ko/Microsoft.TestPlatform.CrossPlatEngine.resources.dll ko/Microsoft.VisualStudio.TestPlatform.Common.resources.dll ko/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll node_modules/package.js one/mycmd opts/-dash opts/bar opts/foo pl/Microsoft.TestPlatform.CommunicationUtilities.resources.dll pl/Microsoft.TestPlatform.CoreUtilities.resources.dll pl/Microsoft.TestPlatform.CrossPlatEngine.resources.dll pl/Microsoft.VisualStudio.TestPlatform.Common.resources.dll pl/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll pt-BR/Microsoft.TestPlatform.CommunicationUtilities.resources.dll pt-BR/Microsoft.TestPlatform.CoreUtilities.resources.dll pt-BR/Microsoft.TestPlatform.CrossPlatEngine.resources.dll pt-BR/Microsoft.VisualStudio.TestPlatform.Common.resources.dll pt-BR/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll ref/Microsoft.CSharp.dll ref/Microsoft.VisualBasic.Core.dll ref/Microsoft.VisualBasic.dll ref/Microsoft.Win32.Primitives.dll ref/Microsoft.Win32.Registry.dll ref/System.AppContext.dll ref/System.Buffers.dll ref/System.Collections.Concurrent.dll ref/System.Collections.Immutable.dll ref/System.Collections.NonGeneric.dll ref/System.Collections.Specialized.dll ref/System.Collections.dll ref/System.ComponentModel.Annotations.dll ref/System.ComponentModel.DataAnnotations.dll ref/System.ComponentModel.EventBasedAsync.dll ref/System.ComponentModel.Primitives.dll ref/System.ComponentModel.TypeConverter.dll ref/System.ComponentModel.dll ref/System.Configuration.dll ref/System.Console.dll ref/System.Core.dll ref/System.Data.Common.dll ref/System.Data.DataSetExtensions.dll ref/System.Data.dll ref/System.Diagnostics.Contracts.dll ref/System.Diagnostics.Debug.dll ref/System.Diagnostics.DiagnosticSource.dll ref/System.Diagnostics.FileVersionInfo.dll ref/System.Diagnostics.Process.dll ref/System.Diagnostics.StackTrace.dll ref/System.Diagnostics.TextWriterTraceListener.dll ref/System.Diagnostics.Tools.dll ref/System.Diagnostics.TraceSource.dll ref/System.Diagnostics.Tracing.dll ref/System.Drawing.Primitives.dll ref/System.Drawing.dll ref/System.Dynamic.Runtime.dll ref/System.Formats.Asn1.dll ref/System.Formats.Tar.dll ref/System.Globalization.Calendars.dll ref/System.Globalization.Extensions.dll ref/System.Globalization.dll ref/System.IO.Compression.Brotli.dll ref/System.IO.Compression.FileSystem.dll ref/System.IO.Compression.ZipFile.dll ref/System.IO.Compression.dll ref/System.IO.FileSystem.AccessControl.dll ref/System.IO.FileSystem.DriveInfo.dll ref/System.IO.FileSystem.Primitives.dll ref/System.IO.FileSystem.Watcher.dll ref/System.IO.FileSystem.dll ref/System.IO.IsolatedStorage.dll ref/System.IO.MemoryMappedFiles.dll ref/System.IO.Pipes.AccessControl.dll ref/System.IO.Pipes.dll ref/System.IO.UnmanagedMemoryStream.dll ref/System.IO.dll ref/System.Linq.Expressions.dll ref/System.Linq.Parallel.dll ref/System.Linq.Queryable.dll ref/System.Linq.dll ref/System.Memory.dll ref/System.Net.Http.Json.dll ref/System.Net.Http.dll ref/System.Net.HttpListener.dll ref/System.Net.Mail.dll ref/System.Net.NameResolution.dll ref/System.Net.NetworkInformation.dll ref/System.Net.Ping.dll ref/System.Net.Primitives.dll ref/System.Net.Quic.dll ref/System.Net.Requests.dll ref/System.Net.Security.dll ref/System.Net.ServicePoint.dll ref/System.Net.Sockets.dll ref/System.Net.WebClient.dll ref/System.Net.WebHeaderCollection.dll ref/System.Net.WebProxy.dll ref/System.Net.WebSockets.Client.dll ref/System.Net.WebSockets.dll ref/System.Net.dll ref/System.Numerics.Vectors.dll ref/System.Numerics.dll ref/System.ObjectModel.dll ref/System.Reflection.DispatchProxy.dll ref/System.Reflection.Emit.ILGeneration.dll ref/System.Reflection.Emit.Lightweight.dll ref/System.Reflection.Emit.dll ref/System.Reflection.Extensions.dll ref/System.Reflection.Metadata.dll ref/System.Reflection.Primitives.dll ref/System.Reflection.TypeExtensions.dll ref/System.Reflection.dll ref/System.Resources.Reader.dll ref/System.Resources.ResourceManager.dll ref/System.Resources.Writer.dll ref/System.Runtime.CompilerServices.Unsafe.dll ref/System.Runtime.CompilerServices.VisualC.dll ref/System.Runtime.Extensions.dll ref/System.Runtime.Handles.dll ref/System.Runtime.InteropServices.JavaScript.dll ref/System.Runtime.InteropServices.RuntimeInformation.dll ref/System.Runtime.InteropServices.dll ref/System.Runtime.Intrinsics.dll ref/System.Runtime.Loader.dll ref/System.Runtime.Numerics.dll ref/System.Runtime.Serialization.Formatters.dll ref/System.Runtime.Serialization.Json.dll ref/System.Runtime.Serialization.Primitives.dll ref/System.Runtime.Serialization.Xml.dll ref/System.Runtime.Serialization.dll ref/System.Runtime.dll ref/System.Security.AccessControl.dll ref/System.Security.Claims.dll ref/System.Security.Cryptography.Algorithms.dll ref/System.Security.Cryptography.Cng.dll ref/System.Security.Cryptography.Csp.dll ref/System.Security.Cryptography.Encoding.dll ref/System.Security.Cryptography.OpenSsl.dll ref/System.Security.Cryptography.Primitives.dll ref/System.Security.Cryptography.X509Certificates.dll ref/System.Security.Cryptography.dll ref/System.Security.Principal.Windows.dll ref/System.Security.Principal.dll ref/System.Security.SecureString.dll ref/System.Security.dll ref/System.ServiceModel.Web.dll ref/System.ServiceProcess.dll ref/System.Text.Encoding.CodePages.dll ref/System.Text.Encoding.Extensions.dll ref/System.Text.Encoding.dll ref/System.Text.Encodings.Web.dll ref/System.Text.Json.dll ref/System.Text.RegularExpressions.dll ref/System.Threading.Channels.dll ref/System.Threading.Overlapped.dll ref/System.Threading.Tasks.Dataflow.dll ref/System.Threading.Tasks.Extensions.dll ref/System.Threading.Tasks.Parallel.dll ref/System.Threading.Tasks.dll ref/System.Threading.Thread.dll ref/System.Threading.ThreadPool.dll ref/System.Threading.Timer.dll ref/System.Threading.dll ref/System.Transactions.Local.dll ref/System.Transactions.dll ref/System.ValueTuple.dll ref/System.Web.HttpUtility.dll ref/System.Web.dll ref/System.Windows.dll ref/System.Xml.Linq.dll ref/System.Xml.ReaderWriter.dll ref/System.Xml.Serialization.dll ref/System.Xml.XDocument.dll ref/System.Xml.XPath.XDocument.dll ref/System.Xml.XPath.dll ref/System.Xml.XmlDocument.dll ref/System.Xml.XmlSerializer.dll ref/System.Xml.dll ref/System.dll ref/WindowsBase.dll ref/mscorlib.dll ref/netstandard.dll ru/Microsoft.TestPlatform.CommunicationUtilities.resources.dll ru/Microsoft.TestPlatform.CoreUtilities.resources.dll ru/Microsoft.TestPlatform.CrossPlatEngine.resources.dll ru/Microsoft.VisualStudio.TestPlatform.Common.resources.dll ru/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll runtimes/unix runtimes/win src/__init__.py src/__main__.py src/a.js src/b.js tr/Microsoft.TestPlatform.CommunicationUtilities.resources.dll tr/Microsoft.TestPlatform.CoreUtilities.resources.dll tr/Microsoft.TestPlatform.CrossPlatEngine.resources.dll tr/Microsoft.VisualStudio.TestPlatform.Common.resources.dll tr/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll two/mycmd x/test.ifs.'.txt x/test.ifs.*.txt x/test.ifs.\.txt x/test.ifs.\b.txt x/test.ifs.a.txt zh-Hans/Microsoft.TestPlatform.CommunicationUtilities.resources.dll zh-Hans/Microsoft.TestPlatform.CoreUtilities.resources.dll zh-Hans/Microsoft.TestPlatform.CrossPlatEngine.resources.dll zh-Hans/Microsoft.VisualStudio.TestPlatform.Common.resources.dll zh-Hans/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll zh-Hant/Microsoft.TestPlatform.CommunicationUtilities.resources.dll zh-Hant/Microsoft.TestPlatform.CoreUtilities.resources.dll zh-Hant/Microsoft.TestPlatform.CrossPlatEngine.resources.dll zh-Hant/Microsoft.VisualStudio.TestPlatform.Common.resources.dll zh-Hant/Microsoft.VisualStudio.TestPlatform.ObjectModel.resources.dll
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Ignore globs with char patterns like [!ab]
rm -rf _tmp
touch {a,b,c,d,A,B,C,D}
GLOBIGNORE=*[ab]*
echo *
GLOBIGNORE=*[ABC]*
echo *
GLOBIGNORE=*[!ab]*
echo *
## STDOUT:
0 1 1.txt 10 10.txt 2 2 3 c d 3 B Newtonsoft.Json.dll OSCFLAGS c compose cs d de dir1 dir2 directory dist eg1 eg10 eg11 eg2 eg4 eg5 eg6 eg7 eg8 eg9 err.txt es extpipe foo foo. foo.cc foo.h foo.hh foo.txt fr hello hello.c hello.h hello.o hi.txt it ko myfile node_modules one one-* one.md one.txt opts pl pt-BR ref ru runtimes smoke1.txt src testhost.dll testhost.exe tmp.txt tr two x xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json y.Y yy.Y zz-*-xx
0 1 1.txt 10 10.txt 2 2 3 c d 3 Microsoft.TestPlatform.Utilities.dll Microsoft.VisualStudio.TestPlatform.ObjectModel.dll Newtonsoft.Json.dll Parlot.dll _failglob _noglob a bar.cc bar.h bar.txt baz.h c compose cs d de dir1 dir2 directory dist eg1 eg10 eg11 eg2 eg4 eg5 eg6 eg7 eg8 eg9 err.txt es extglob2 extpipe filename foo foo bar foo-bar foo-spam foo. foo.cc foo.h foo.hh foo.txt fr hello hello.c hello.h hello.o hi.txt it ja ko leaf.md myfile node_modules one one-* one-bar one.md one.txt opts pl process-sub.txt ps-bash-host.deps.json ps-bash-host.exe ps-bash-host.runtimeconfig.json ps-bash.deps.json ps-bash.exe ps-bash.runtimeconfig.json ref ru runtimes smoke1.txt src testhost.dll testhost.exe tmp.txt tr traps.txt two two-bar x xunit.abstractions.dll xunit.assert.dll xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json xunit.runner.reporters.netcoreapp10.dll xunit.runner.utility.netcoreapp10.dll xunit.runner.visualstudio.testadapter.dll y.Y yy.Y zh-Hans zh-Hant zz-*-xx
a
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Ignore globs with char classes like [[:alnum:]]
touch {_testing.py,pyproject.toml,20231114.log,.env}
touch 'has space.docx'
GLOBIGNORE=[[:alnum:]]*
echo *.*
GLOBIGNORE=[![:alnum:]]*
echo *.*
GLOBIGNORE=*[[:space:]]*
echo *.*
GLOBIGNORE=[[:digit:]_.]*
echo *.*
## STDOUT:
.env .msCoverageSourceRootsMapping_PsBash.Spec.Tests _testing.py
1.txt 10.txt 20231114.log Microsoft.TestPlatform.CommunicationUtilities.dll Microsoft.TestPlatform.CoreUtilities.dll Microsoft.TestPlatform.CrossPlatEngine.dll Microsoft.TestPlatform.PlatformAbstractions.dll Microsoft.TestPlatform.Utilities.dll Microsoft.VisualStudio.CodeCoverage.Shim.dll Microsoft.VisualStudio.TestPlatform.Common.dll Microsoft.VisualStudio.TestPlatform.ObjectModel.dll Newtonsoft.Json.dll Parlot.dll PsBash.Core.dll PsBash.Core.pdb PsBash.Core.xml PsBash.Spec.Tests.deps.json PsBash.Spec.Tests.dll PsBash.Spec.Tests.pdb PsBash.Spec.Tests.runtimeconfig.json PsBash.Spec.dll PsBash.Spec.pdb PsBash.Testing.dll PsBash.Testing.pdb PsBash.Transpiler.dll PsBash.Transpiler.pdb PsBash.Transpiler.xml bar.cc bar.h bar.txt baz.h err.txt foo. foo.cc foo.h foo.hh foo.txt has space.docx hello.c hello.h hello.o hi.txt leaf.md one.md one.txt process-sub.txt ps-bash-host.deps.json ps-bash-host.exe ps-bash-host.runtimeconfig.json ps-bash.deps.json ps-bash.exe ps-bash.runtimeconfig.json pyproject.toml smoke1.txt testhost.dll testhost.exe tmp.txt traps.txt xunit.abstractions.dll xunit.assert.dll xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json xunit.runner.reporters.netcoreapp10.dll xunit.runner.utility.netcoreapp10.dll xunit.runner.visualstudio.testadapter.dll y.Y yy.Y
.env .msCoverageSourceRootsMapping_PsBash.Spec.Tests 1.txt 10.txt 20231114.log Microsoft.TestPlatform.CommunicationUtilities.dll Microsoft.TestPlatform.CoreUtilities.dll Microsoft.TestPlatform.CrossPlatEngine.dll Microsoft.TestPlatform.PlatformAbstractions.dll Microsoft.TestPlatform.Utilities.dll Microsoft.VisualStudio.CodeCoverage.Shim.dll Microsoft.VisualStudio.TestPlatform.Common.dll Microsoft.VisualStudio.TestPlatform.ObjectModel.dll Newtonsoft.Json.dll Parlot.dll PsBash.Core.dll PsBash.Core.pdb PsBash.Core.xml PsBash.Spec.Tests.deps.json PsBash.Spec.Tests.dll PsBash.Spec.Tests.pdb PsBash.Spec.Tests.runtimeconfig.json PsBash.Spec.dll PsBash.Spec.pdb PsBash.Testing.dll PsBash.Testing.pdb PsBash.Transpiler.dll PsBash.Transpiler.pdb PsBash.Transpiler.xml _testing.py bar.cc bar.h bar.txt baz.h err.txt foo. foo.cc foo.h foo.hh foo.txt hello.c hello.h hello.o hi.txt leaf.md one.md one.txt process-sub.txt ps-bash-host.deps.json ps-bash-host.exe ps-bash-host.runtimeconfig.json ps-bash.deps.json ps-bash.exe ps-bash.runtimeconfig.json pyproject.toml smoke1.txt testhost.dll testhost.exe tmp.txt traps.txt xunit.abstractions.dll xunit.assert.dll xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json xunit.runner.reporters.netcoreapp10.dll xunit.runner.utility.netcoreapp10.dll xunit.runner.visualstudio.testadapter.dll y.Y yy.Y
Microsoft.TestPlatform.CommunicationUtilities.dll Microsoft.TestPlatform.CoreUtilities.dll Microsoft.TestPlatform.CrossPlatEngine.dll Microsoft.TestPlatform.PlatformAbstractions.dll Microsoft.TestPlatform.Utilities.dll Microsoft.VisualStudio.CodeCoverage.Shim.dll Microsoft.VisualStudio.TestPlatform.Common.dll Microsoft.VisualStudio.TestPlatform.ObjectModel.dll Newtonsoft.Json.dll Parlot.dll PsBash.Core.dll PsBash.Core.pdb PsBash.Core.xml PsBash.Spec.Tests.deps.json PsBash.Spec.Tests.dll PsBash.Spec.Tests.pdb PsBash.Spec.Tests.runtimeconfig.json PsBash.Spec.dll PsBash.Spec.pdb PsBash.Testing.dll PsBash.Testing.pdb PsBash.Transpiler.dll PsBash.Transpiler.pdb PsBash.Transpiler.xml bar.cc bar.h bar.txt baz.h err.txt foo. foo.cc foo.h foo.hh foo.txt has space.docx hello.c hello.h hello.o hi.txt leaf.md one.md one.txt process-sub.txt ps-bash-host.deps.json ps-bash-host.exe ps-bash-host.runtimeconfig.json ps-bash.deps.json ps-bash.exe ps-bash.runtimeconfig.json pyproject.toml smoke1.txt testhost.dll testhost.exe tmp.txt traps.txt xunit.abstractions.dll xunit.assert.dll xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json xunit.runner.reporters.netcoreapp10.dll xunit.runner.utility.netcoreapp10.dll xunit.runner.visualstudio.testadapter.dll y.Y yy.Y
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Ignore *
# This pattern appears in public repositories
touch {1.txt,2.log,3.md}
GLOBIGNORE=*
echo *
## stdout: *
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### treat escaped patterns literally
touch {escape-10.txt,escape*.txt}
GLOBIGNORE="escape\*.txt"
echo *.*
## stdout: .env .msCoverageSourceRootsMapping_PsBash.Spec.Tests 1.txt 10.txt 2.log 20231114.log 3.md Microsoft.TestPlatform.CommunicationUtilities.dll Microsoft.TestPlatform.CoreUtilities.dll Microsoft.TestPlatform.CrossPlatEngine.dll Microsoft.TestPlatform.PlatformAbstractions.dll Microsoft.TestPlatform.Utilities.dll Microsoft.VisualStudio.CodeCoverage.Shim.dll Microsoft.VisualStudio.TestPlatform.Common.dll Microsoft.VisualStudio.TestPlatform.ObjectModel.dll Newtonsoft.Json.dll Parlot.dll PsBash.Core.dll PsBash.Core.pdb PsBash.Core.xml PsBash.Spec.Tests.deps.json PsBash.Spec.Tests.dll PsBash.Spec.Tests.pdb PsBash.Spec.Tests.runtimeconfig.json PsBash.Spec.dll PsBash.Spec.pdb PsBash.Testing.dll PsBash.Testing.pdb PsBash.Transpiler.dll PsBash.Transpiler.pdb PsBash.Transpiler.xml _testing.py bar.cc bar.h bar.txt baz.h err.txt escape-10.txt foo. foo.cc foo.h foo.hh foo.txt has space.docx hello.c hello.h hello.o hi.txt image.jpeg leaf.md one.md one.txt process-sub.txt ps-bash-host.deps.json ps-bash-host.exe ps-bash-host.runtimeconfig.json ps-bash.deps.json ps-bash.exe ps-bash.runtimeconfig.json pyproject.toml reset.txt smoke1.txt testhost.dll testhost.exe tmp.txt traps.txt xunit.abstractions.dll xunit.assert.dll xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json xunit.runner.reporters.netcoreapp10.dll xunit.runner.utility.netcoreapp10.dll xunit.runner.visualstudio.testadapter.dll y.Y yy.Y
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### resetting globignore reverts to default behaviour
touch reset.txt
GLOBIGNORE=*.txt
echo *.*
GLOBIGNORE=
echo *.*
## STDOUT:
.env .msCoverageSourceRootsMapping_PsBash.Spec.Tests 2.log 20231114.log 3.md Microsoft.TestPlatform.CommunicationUtilities.dll Microsoft.TestPlatform.CoreUtilities.dll Microsoft.TestPlatform.CrossPlatEngine.dll Microsoft.TestPlatform.PlatformAbstractions.dll Microsoft.TestPlatform.Utilities.dll Microsoft.VisualStudio.CodeCoverage.Shim.dll Microsoft.VisualStudio.TestPlatform.Common.dll Microsoft.VisualStudio.TestPlatform.ObjectModel.dll Newtonsoft.Json.dll Parlot.dll PsBash.Core.dll PsBash.Core.pdb PsBash.Core.xml PsBash.Spec.Tests.deps.json PsBash.Spec.Tests.dll PsBash.Spec.Tests.pdb PsBash.Spec.Tests.runtimeconfig.json PsBash.Spec.dll PsBash.Spec.pdb PsBash.Testing.dll PsBash.Testing.pdb PsBash.Transpiler.dll PsBash.Transpiler.pdb PsBash.Transpiler.xml _testing.py bar.cc bar.h baz.h foo. foo.cc foo.h foo.hh has space.docx hello.c hello.h hello.o leaf.md one.md ps-bash-host.deps.json ps-bash-host.exe ps-bash-host.runtimeconfig.json ps-bash.deps.json ps-bash.exe ps-bash.runtimeconfig.json pyproject.toml testhost.dll testhost.exe xunit.abstractions.dll xunit.assert.dll xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json xunit.runner.reporters.netcoreapp10.dll xunit.runner.utility.netcoreapp10.dll xunit.runner.visualstudio.testadapter.dll y.Y yy.Y
.env .msCoverageSourceRootsMapping_PsBash.Spec.Tests 1.txt 10.txt 2.log 20231114.log 3.md Microsoft.TestPlatform.CommunicationUtilities.dll Microsoft.TestPlatform.CoreUtilities.dll Microsoft.TestPlatform.CrossPlatEngine.dll Microsoft.TestPlatform.PlatformAbstractions.dll Microsoft.TestPlatform.Utilities.dll Microsoft.VisualStudio.CodeCoverage.Shim.dll Microsoft.VisualStudio.TestPlatform.Common.dll Microsoft.VisualStudio.TestPlatform.ObjectModel.dll Newtonsoft.Json.dll Parlot.dll PsBash.Core.dll PsBash.Core.pdb PsBash.Core.xml PsBash.Spec.Tests.deps.json PsBash.Spec.Tests.dll PsBash.Spec.Tests.pdb PsBash.Spec.Tests.runtimeconfig.json PsBash.Spec.dll PsBash.Spec.pdb PsBash.Testing.dll PsBash.Testing.pdb PsBash.Transpiler.dll PsBash.Transpiler.pdb PsBash.Transpiler.xml _testing.py _testing.py bar.cc bar.h bar.txt baz.h err.txt escape-10.txt foo. foo.cc foo.h foo.hh foo.txt has space.docx hello.c hello.h hello.o hi.txt leaf.md one.md one.txt process-sub.txt ps-bash-host.deps.json ps-bash-host.exe ps-bash-host.runtimeconfig.json ps-bash.deps.json ps-bash.exe ps-bash.runtimeconfig.json pyproject.toml reset.txt smoke1.txt testhost.dll testhost.exe tmp.txt traps.txt xunit.abstractions.dll xunit.assert.dll xunit.core.dll xunit.execution.dotnet.dll xunit.runner.json xunit.runner.reporters.netcoreapp10.dll xunit.runner.utility.netcoreapp10.dll xunit.runner.visualstudio.testadapter.dll y.Y yy.Y
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Ignore .:..
# globskipdots is enabled by default in bash >=5.2
# for bash <5.2 this pattern is a common way to match dotfiles but not . or ..
shopt -u globskipdots
touch .env
GLOBIGNORE=.:..
echo .*
GLOBIGNORE=
echo .* | sort
## STDOUT:
.env .msCoverageSourceRootsMapping_PsBash.Spec.Tests
. .. .env .msCoverageSourceRootsMapping_PsBash.Spec.Tests
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Quoting GLOBIGNORE
# each style of "ignore everything" spotted in a public repo
touch image.jpeg
GLOBIGNORE=*
echo *
GLOBIGNORE='*'
echo *
GLOBIGNORE="*"
echo *
GLOBIGNORE=\*
echo *
## STDOUT:
*
*
*
*
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### . and .. always filtered when GLOBIGNORE is set
# When GLOBIGNORE is set to any non-null value, . and .. are always filtered
touch .hidden
GLOBIGNORE=*.txt

echo .*
shopt -u globskipdots
echo .*
## STDOUT:
.env .hidden .msCoverageSourceRootsMapping_PsBash.Spec.Tests
.env .hidden .msCoverageSourceRootsMapping_PsBash.Spec.Tests
## END
## status: 0
## timeout: 10

#### When GLOBIGNORE is set, glob may become empty (nullglob too)
touch -- foo.txt -foo.txt

echo *t

GLOBIGNORE=*.txt
echo *t

shopt -s nullglob
echo nullglob *t
## STDOUT:
-foo.txt 1.txt 10.txt bar.txt dist err.txt escape*.txt escape-10.txt foo.txt hi.txt it one.txt process-sub.txt reset.txt smoke1.txt tmp.txt traps.txt zh-Hant
dist it zh-Hant
nullglob dist it zh-Hant
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10

#### Extended glob expansion combined with GLOBIGNORE
shopt -s extglob

touch foo.cc foo.h bar.cc bar.h 
echo @(*.cc|*.h)
GLOBIGNORE=foo.*
echo @(*.cc|*.h)
## STDOUT:
bar.cc bar.h baz.h foo.cc foo.h hello.h
bar.cc bar.h baz.h hello.h
## END
## status: 0
## XFAIL ps-bash triage differs from bash 5.2 (auto-marked; investigate)
## timeout: 10
