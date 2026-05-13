class RaftRx < Formula
  desc "Raft consensus algorithm over rxnet — C implementation"
  homepage "https://github.com/greenlsi/raft_rx"
  url "https://github.com/greenlsi/raft_rx/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f065dcbd94e162be9a4fa78966ab59e0f2b3be37a502304662833e664d24e87f"
  version "0.1.0"
  license "GPL-3.0-or-later"

  depends_on "rxnet"

  def install
    rxnet = Formula["rxnet"]
    system "make", "-C", "c",
           "build/libraft_rx.a",
           "build/libraft_rx_trace.a",
           "CFLAGS=-std=c99 -O2 -Wall -Wextra -Iinclude -I#{rxnet.include}",
           "RXNET_LIB=#{rxnet.lib}/librxnet.a",
           "RXNET_TRACE_LIB=#{rxnet.lib}/librxnet_trace.a"
    lib.install Dir["c/build/libraft_rx*.a"]
    (include/"raft").install Dir["c/include/raft/*.h"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <raft/raft.h>
      int main(void) { (void)sizeof(raft_command_t); return 0; }
    C
    system ENV.cc, "-std=c99",
           "-I#{include}", "-I#{Formula["rxnet"].include}",
           "test.c", "-L#{lib}", "-lraft_rx", "-o", "test"
    system "./test"
  end
end
