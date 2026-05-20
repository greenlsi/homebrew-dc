class Rxnet < Formula
  desc "Reactive synchronous runtime library — C implementation"
  homepage "https://github.com/greenlsi/rxnet"
  url "https://github.com/greenlsi/rxnet/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "7d3f97746764db7e181ce7fe864170598047c3875e6df9a85e00e4f93928a00b"
  version "1.1.3"
  license "GPL-3.0-or-later"

  def install
    system "make", "-C", "c", "lib"
    lib.install Dir["c/build/librxnet*.a"]
    (include/"rxnet").install Dir["c/include/rxnet/*.h"]
    (include/"rxnet/port").install Dir["c/include/rxnet/port/*.h"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rxnet/runtime.h>
      int main(void) { (void)sizeof(rx_runtime); return 0; }
    C
    system ENV.cc, "-std=c99", "-I#{include}", "test.c", "-L#{lib}", "-lrxnet", "-o", "test"
    system "./test"
  end
end
