class Rxnet < Formula
  desc "Reactive synchronous runtime library — C implementation"
  homepage "https://github.com/greenlsi/rxnet"
  url "https://github.com/greenlsi/rxnet/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "266a82e9c222da27acac0cac9656b2019c396a3d6161b76af5c2cc6b01b53b48"
  version "1.0.1"
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
