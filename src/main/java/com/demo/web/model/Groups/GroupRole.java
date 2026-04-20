package com.demo.web.model.Groups;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public enum GroupRole {
    ADMIN("admin", "Admin", false, true),
    EDITOR("editor", "Editor", true, true),
    VIEWER("viewer", "Viewer", true, false);

    private final String value;
    private final String label;
    private final boolean assignableByAdmin;
    private final boolean canCreateMemories;

    GroupRole(String value, String label, boolean assignableByAdmin, boolean canCreateMemories) {
        this.value = value;
        this.label = label;
        this.assignableByAdmin = assignableByAdmin;
        this.canCreateMemories = canCreateMemories;
    }

    public String getValue() {
        return value;
    }

    public String getLabel() {
        return label;
    }

    public boolean isAssignableByAdmin() {
        return assignableByAdmin;
    }

    public boolean canCreateMemories() {
        return canCreateMemories;
    }

    public static GroupRole fromValue(String rawRole) {
        if (rawRole == null) {
            return null;
        }
        String normalized = rawRole.trim().toLowerCase(Locale.ROOT);
        for (GroupRole role : values()) {
            if (role.value.equals(normalized)) {
                return role;
            }
        }
        return null;
    }

    public static String normalize(String rawRole) {
        GroupRole role = fromValue(rawRole);
        return role != null ? role.getValue() : rawRole;
    }

    public static List<GroupRole> assignableByAdmin() {
        List<GroupRole> options = new ArrayList<>();
        for (GroupRole role : values()) {
            if (role.isAssignableByAdmin()) {
                options.add(role);
            }
        }
        return options;
    }

    public static String assignableRoleSummary() {
        StringBuilder builder = new StringBuilder();
        List<GroupRole> options = assignableByAdmin();
        for (int i = 0; i < options.size(); i++) {
            if (i > 0) {
                builder.append(" or ");
            }
            builder.append(options.get(i).getValue());
        }
        return builder.toString();
    }
}
