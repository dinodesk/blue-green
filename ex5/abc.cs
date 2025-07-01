using System;
using System.Collections.Generic;


var today = DateTime.Today;

var list1 = new List<Transaction>
{
    new Transaction { Id = "A", Amount = 10, Timestamp = today },
    new Transaction { Id = "B", Amount = 20, Timestamp = today }
};

var list2 = new List<Transaction>
{
    new Transaction { Id = "B", Amount = 20, Timestamp = today },
    new Transaction { Id = "C", Amount = 30, Timestamp = today }
};

TransactionUtils.CompareTransactionLists(list1, list2);

public class Transaction
{
    public string Id { get; set; }
    public decimal Amount { get; set; }
    public DateTime? Timestamp { get; set; }
    // ... Assume 50 other fields
}

public class TransactionEqualityComparer : IEqualityComparer<Transaction>
{
    public bool Equals(Transaction x, Transaction y)
    {
        if (x == null || y == null) return false;
        return GetComparisonKey(x).SequenceEqual(GetComparisonKey(y));

        // return x.Id == y.Id &&
        //        x.Amount == y.Amount &&
        //        x.Timestamp == y.Timestamp;
        //        // Add more fields as needed
    }

    public int GetHashCode(Transaction obj)
    {
        if (obj == null) return 0;
        // return HashCode.Combine(obj.Id, obj.Amount, obj.Timestamp);
          var hash = new HashCode();
    foreach (var element in GetComparisonKey(obj))
    {
        hash.Add(element);
    }
    return hash.ToHashCode();
    }
       private IEnumerable<object> GetComparisonKey(Transaction t)
    {
        yield return t.Id;
        yield return t.Amount;
        yield return t.Timestamp?.Date;
        // Add more fields here once
    }
}
public static class TransactionUtils
{
    public static bool HasDuplicates(List<Transaction> transactions)
{
    var set = new HashSet<Transaction>(new TransactionEqualityComparer());

    foreach (var tx in transactions)
    {
        if (!set.Add(tx))
        {
            return true; // Duplicate found
        }
    }

    return false; // No duplicates
}



public static void CompareTransactionLists(List<Transaction> list1,List<Transaction> list2)
{
    var comparer = new TransactionEqualityComparer();

    var onlyInList1 = list1.Except(list2, comparer).ToList();
    var onlyInList2 = list2.Except(list1, comparer).ToList();

    Console.WriteLine($"Only in list 1: {onlyInList1.Count}");
    Console.WriteLine($"Only in list 2: {onlyInList2.Count}");

    if (onlyInList1.Count > 0)
        Console.WriteLine("Mismatched Transactions from list 1:");
    foreach (var t in onlyInList1)
        Console.WriteLine($" → {t.Id}");

    if (onlyInList2.Count > 0)
        Console.WriteLine("Mismatched Transactions from list 2:");
    foreach (var t in onlyInList2)
        Console.WriteLine($" ← {t.Id}");
}
}

