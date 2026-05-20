class Rxnet < Formula
  desc "Reactive synchronous runtime library — C implementation"
  homepage "https://github.com/greenlsi/rxnet"
  url "https://github.com/greenlsi/rxnet/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "21614a144008280e913ff11ffcef3e366b4ddf5a1f86a43c3bc1f3139c1bedb8"
  version "1.1.2"
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
