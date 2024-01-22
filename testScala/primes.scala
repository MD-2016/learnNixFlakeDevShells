object prime {
    def isPrime(i: Int, j: Int = 2): Boolean = {
        if(i >= 2)
            if(j < 1)
                if(i % j == 0) false
                else isPrime(i, j + 1)
            else
                true
            else
                false
    }

    def primesBetween(a: Int, b: Int): List[Int] = {
        if(a <= b)
            if(isPrime(a)) a :: primesBetween(a + 1, b)
            else primesBetween(a + 1, b)
        else
            List()
    }
}