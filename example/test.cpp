#include <gtest/gtest.h>


TEST(Dummy, fail)
{
    FAIL() << "I am a failure";
}

TEST(Dummy, pass)
{
    ASSERT_TRUE(true);
}
