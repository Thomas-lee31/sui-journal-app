/*
/// Module: journal
module journal::journal;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module journal::journal;

use std::string::String;
use sui::clock::Clock;

/// A struct representing a journal entry
public struct Entry has store {
    content: String,
    create_at_ms: u64,
}

/// An owned Sui object representing a journal
public struct Journal has key, store {
    id: UID,
    owner: address,
    title: String,
    entries: vector<Entry>,
}

public fun new_journal(title: String, ctx: &mut TxContext): Journal {
    let journal = Journal {
        id: object::new(ctx),
        owner: ctx.sender(),
        title,
        entries: vector::empty(),
    };

    journal
}

/// Adds a new entry to the journal
/// Verifies the caller is the journal owner
public fun add_entry(
    journal: &mut Journal,
    content: String,
    clock: &Clock,
    ctx: &TxContext,
) {
    // Verify the caller is the journal owner
    assert!(journal.owner == ctx.sender(), 0);

    // Create a new Entry with the content and current timestamp
    let new_entry = Entry {
        content,
        create_at_ms: clock.timestamp_ms(),
    };

    // Add the entry to the journal's entries vector
    journal.entries.push_back(new_entry);
}
