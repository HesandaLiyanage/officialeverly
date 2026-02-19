-- Junction table for many-to-many relationship between events and groups
CREATE TABLE IF NOT EXISTS event_group (
    event_id   INT NOT NULL REFERENCES event(event_id) ON DELETE CASCADE,
    group_id   INT NOT NULL REFERENCES "group"(group_id) ON DELETE CASCADE,
    PRIMARY KEY (event_id, group_id)
);

-- Migrate existing data from the event.group_id column
INSERT INTO event_group (event_id, group_id)
SELECT event_id, group_id FROM event WHERE group_id IS NOT NULL
ON CONFLICT DO NOTHING;
