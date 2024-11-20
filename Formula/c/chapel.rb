  include Language::Python::Shebang
  url "https://github.com/chapel-lang/chapel/releases/download/2.2.0/chapel-2.2.0.tar.gz"
  sha256 "bb16952a87127028031fd2b56781bea01ab4de7c3466f7b6a378c4d8895754b6"
    rebuild 1
    sha256 arm64_sequoia: "86a564896112278e0aee551ad00254242ff7eb374da45f945352beb6df974999"
    sha256 arm64_sonoma:  "82a836c46c1742bda66bfe00cc382597007b29dd9a1261eab74316095f0b0790"
    sha256 arm64_ventura: "617283fed12c23b9d61023f77c1b82536b9064913761dd3b266d7055242b2e1a"
    sha256 sonoma:        "9e41f26c78876875e0d6cde3ebd54740b10d0054eb2929915ce1390fcc91ab3d"
    sha256 ventura:       "eb0a0093cd3c9ba5a2347f07c59bae86071ca5baaa8861f094db65ca5df6c2fd"
    sha256 x86_64_linux:  "252515f46ddc6ef16ef46edc26a4a6ad4cc352c6513a138a6a607ae5c7280f39"
  depends_on "llvm@18"
  depends_on "python@3.13"
  # update pyyaml to support py3.13 build, upstream pr ref, https://github.com/chapel-lang/chapel/pull/26079
    python = "python3.13"
    # It should be noted that this will expand to: 'for cmd in python3.13 python3 python python2; do'
    inreplace "third-party/chpl-venv/Makefile", "python3 -c ", "#{python} -c "

    # a lot of scripts have a python3 or python shebang, which does not point to python3.12 anymore
    Pathname.glob("**/*.py") do |pyfile|
      rewrite_shebang detected_python_shebang, pyfile
    end
    ENV["CHPL_CMAKE_PYTHON"] = python
      rm_r("third-party/gasnet/gasnet-src/")
      rm_r("third-party/libfabric/libfabric-src/")
      rm_r("third-party/fltk/fltk-1.3.8-source.tar.gz")
      rm_r("third-party/libunwind/libunwind-src/")
      rm_r("third-party/qthread/qthread-src/")
diff --git a/third-party/chpl-venv/test-requirements.txt b/third-party/chpl-venv/test-requirements.txt
index a8f97300..2da4f7de 100644
--- a/third-party/chpl-venv/test-requirements.txt
+++ b/third-party/chpl-venv/test-requirements.txt
@@ -1,4 +1,4 @@
-PyYAML==6.0.1
+PyYAML==6.0.2
 filelock==3.12.2
 argcomplete==3.1.2
 setuptools==68.0.0