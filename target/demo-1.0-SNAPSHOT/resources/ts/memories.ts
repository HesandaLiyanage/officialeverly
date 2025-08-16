// TypeScript interfaces and types for Memories page
interface Memory {
    id: string;
    title: string;
    date: string;
    imageUrl: string;
    location?: string;
    isFavorited: boolean;
    tags?: string[];
}

interface FilterOptions {
    date: 'recent' | 'oldest' | 'year' | 'all';
    location: 'all' | 'local' | 'travel';
    searchTerm: string;
}

interface StorageInfo {
    used: number;
    total: number;
    percentage: number;
}

class MemoriesPage {
    private memories: Memory[] = [];
    private filteredMemories: Memory[] = [];
    private filters: FilterOptions = {
        date: 'recent',
        location: 'all',
        searchTerm: ''
    };
    private currentTab: 'memories' | 'collab' = 'memories';
    private isLoading: boolean = false;

    constructor() {
        this.initializeEventListeners();
        this.loadMemories();
        this.updateStorageInfo();
    }

    /**
     * Initialize all event listeners for the page
     */
    private initializeEventListeners(): void {
        // Tab navigation
        this.initializeTabNavigation();

        // Search functionality
        this.initializeSearch();

        // Filter dropdowns
        this.initializeFilters();

        // Memory card interactions
        this.initializeMemoryCards();

        // Sidebar interactions
        this.initializeSidebar();

        // Header interactions
        this.initializeHeader();
    }

    /**
     * Initialize tab navigation functionality
     */
    private initializeTabNavigation(): void {
        const tabButtons = document.querySelectorAll<HTMLButtonElement>('.tab-btn');

        tabButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                const target = e.currentTarget as HTMLButtonElement;
                const tabName = target.getAttribute('data-tab') as 'memories' | 'collab';

                if (tabName && tabName !== this.currentTab) {
                    this.switchTab(tabName);
                }
            });
        });
    }

    /**
     * Switch between tabs
     */
    private switchTab(tabName: 'memories' | 'collab'): void {
        // Update active tab button
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('tab-btn--active');
        });

        const activeBtn = document.querySelector(`[data-tab="${tabName}"]`);
        if (activeBtn) {
            activeBtn.classList.add('tab-btn--active');
        }

        this.currentTab = tabName;
        this.loadMemories();
    }

    /**
     * Initialize search functionality
     */
    private initializeSearch(): void {
        const searchInput = document.getElementById('memoriesSearch') as HTMLInputElement;
        let searchTimeout: NodeJS.Timeout;

        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                const target = e.target as HTMLInputElement;

                // Debounce search
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    this.filters.searchTerm = target.value.toLowerCase().trim();
                    this.applyFilters();
                }, 300);
            });
        }

        // Header search
        const headerSearch = document.getElementById('headerSearch') as HTMLInputElement;
        if (headerSearch) {
            headerSearch.addEventListener('focus', () => {
                // Could implement global search functionality here
            });
        }
    }

    /**
     * Initialize filter dropdown functionality
     */
    private initializeFilters(): void {
        this.initializeDropdown('dateFilter', (value: string) => {
            this.filters.date = value as FilterOptions['date'];
            this.applyFilters();
        });

        this.initializeDropdown('locationFilter', (value: string) => {
            this.filters.location = value as FilterOptions['location'];
            this.applyFilters();
        });
    }

    /**
     * Initialize dropdown functionality
     */
    private initializeDropdown(dropdownId: string, onSelect: (value: string) => void): void {
        const dropdown = document.getElementById(dropdownId);
        if (!dropdown) return;

        const trigger = dropdown.querySelector('.dropdown__trigger') as HTMLButtonElement;
        const content = dropdown.querySelector('.dropdown__content') as HTMLElement;
        const items = dropdown.querySelectorAll('.dropdown__item') as NodeListOf<HTMLAnchorElement>;

        if (!trigger || !content) return;

        // Toggle dropdown
        trigger.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            this.toggleDropdown(dropdown);
        });

        // Handle item selection
        items.forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const value = item.getAttribute('data-value');
                if (value) {
                    onSelect(value);
                    this.updateDropdownTrigger(trigger, item.textContent || '');
                    this.closeDropdown(dropdown);
                }
            });
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', (e) => {
            if (!dropdown.contains(e.target as Node)) {
                this.closeDropdown(dropdown);
            }
        });
    }

    /**
     * Toggle dropdown open/close state
     */
    private toggleDropdown(dropdown: Element): void {
        const isOpen = dropdown.classList.contains('dropdown--open');

        // Close all other dropdowns
        document.querySelectorAll('.dropdown--open').forEach(d => {
            if (d !== dropdown) {
                d.classList.remove('dropdown--open');
            }
        });

        if (isOpen) {
            this.closeDropdown(dropdown);
        } else {
            this.openDropdown(dropdown);
        }
    }

    /**
     * Open dropdown
     */
    private openDropdown(dropdown: Element): void {
        dropdown.classList.add('dropdown--open');
    }

    /**
     * Close dropdown
     */
    private closeDropdown(dropdown: Element): void {
        dropdown.classList.remove('dropdown--open');
    }

    /**
     * Update dropdown trigger text
     */
    private updateDropdownTrigger(trigger: HTMLButtonElement, text: string): void {
        const textNode = Array.from(trigger.childNodes).find(node =>
            node.nodeType === Node.TEXT_NODE
        );
        if (textNode) {
            textNode.textContent = text;
        }
    }

    /**
     * Initialize memory card interactions
     */
    private initializeMemoryCards(): void {
        document.addEventListener('click', (e) => {
            const target = e.target as HTMLElement;

            // Handle favorite button clicks
            if (target.closest('.memory-card__favorite')) {
                e.preventDefault();
                e.stopPropagation();
                this.handleFavoriteClick(target.closest('.memory-card__favorite') as HTMLButtonElement);
                return;
            }

            // Handle memory card clicks
            const memoryCard = target.closest('.memory-card') as HTMLElement;
            if (memoryCard) {
                this.handleMemoryCardClick(memoryCard);
            }
        });
    }

    /**
     * Handle favorite button click
     */
    private handleFavoriteClick(button: HTMLButtonElement): void {
        const memoryCard = button.closest('.memory-card') as HTMLElement;
        const memoryId = memoryCard?.getAttribute('data-memory-id');

        if (!memoryId) return;

        const memory = this.memories.find(m => m.id === memoryId);
        if (!memory) return;

        // Toggle favorite status
        memory.isFavorited = !memory.isFavorited;

        // Update button state
        button.setAttribute('data-favorited', memory.isFavorited.toString());

        // Update icon
        const svg = button.querySelector('svg');
        if (svg) {
            if (memory.isFavorited) {
                svg.setAttribute('fill', 'currentColor');
                svg.removeAttribute('stroke');
            } else {
                svg.setAttribute('fill', 'none');
                svg.setAttribute('stroke', 'currentColor');
            }
        }

        // Add animation
        button.style.transform = 'scale(1.2)';
        setTimeout(() => {
            button.style.transform = '';
        }, 150);

        // Update favorites list
        this.updateFavoritesList();

        // Save to server/storage
        this.saveFavoriteStatus(memoryId, memory.isFavorited);
    }

    /**
     * Handle memory card click
     */
    private handleMemoryCardClick(card: HTMLElement): void {
        const memoryId = card.getAttribute('data-memory-id');
        if (memoryId) {
            // Navigate to memory detail page or open modal
            this.openMemoryDetail(memoryId);
        }
    }

    /**
     * Open memory detail view
     */
    private openMemoryDetail(memoryId: string): void {
        // Implementation would depend on your routing system
        console.log(`Opening memory detail for ${memoryId}`);
        // window.location.href = `/memories/${memoryId}`;
        // or open modal, etc.
    }

    /**
     * Initialize sidebar interactions
     */
    private initializeSidebar(): void {
        // Sidebar section headers
        document.querySelectorAll('.sidebar-section__header').forEach(header => {
            header.addEventListener('click', (e) => {
                const section = (e.currentTarget as HTMLElement).closest('.sidebar-section');
                if (section) {
                    this.toggleSidebarSection(section);
                }
            });
        });

        // Favorite items
        document.querySelectorAll('.favourite-item').forEach(item => {
            item.addEventListener('click', (e) => {
                const text = item.querySelector('.favourite-item__text')?.textContent;
                if (text) {
                    this.filterByFavorite(text);
                }
            });
        });
    }

    /**
     * Toggle sidebar section expand/collapse
     */
    private toggleSidebarSection(section: Element): void {
        // This would implement collapsible sections if needed
        console.log('Toggle sidebar section', section);
    }

    /**
     * Filter memories by favorite item
     */
    private filterByFavorite(favoriteText: string): void {
        this.filters.searchTerm = favoriteText.toLowerCase();
        this.applyFilters();

        // Update search input
        const searchInput = document.getElementById('memoriesSearch') as HTMLInputElement;
        if (searchInput) {
            searchInput.value = favoriteText;
        }
    }

    /**
     * Initialize header interactions
     */
    private initializeHeader(): void {
        const notificationsBtn = document.getElementById('notificationsBtn');
        if (notificationsBtn) {
            notificationsBtn.addEventListener('click', () => {
                this.showNotifications();
            });
        }
    }

    /**
     * Show notifications dropdown/modal
     */
    private showNotifications(): void {
        console.log('Show notifications');
        // Implementation would show notifications
    }

    /**
     * Load memories from server/storage
     */
    private async loadMemories(): Promise<void> {
        this.setLoadingState(true);

        try {
            // Simulate API call
            await new Promise(resolve => setTimeout(resolve, 500));

            // Mock data - in real app, this would come from server
            this.memories = this.getMockMemories();
            this.applyFilters();

        } catch (error) {
            console.error('Error loading memories:', error);
            this.showError('Failed to load memories');
        } finally {
            this.setLoadingState(false);
        }
    }

    /**
     * Get mock memory data
     */
    private getMockMemories(): Memory[] {
        return [
            {
                id: '1',
                title: 'Family Vacation 2023',
                date: '2023-07-15',
                imageUrl: '/images/family-vacation.jpg',
                location: 'Beach Resort',
                isFavorited: false,
                tags: ['family', 'vacation', 'beach']
            },
            {
                id: '2',
                title: "Sarah's Birthday Party",
                date: '2023-05-20',
                imageUrl: '/images/birthday-party.jpg',
                location: 'Home',
                isFavorited: false,
                tags: ['birthday', 'party', 'celebration']
            },
            {
                id: '3',
                title: 'Weekend Getaway',
                date: '2023-04-08',
                imageUrl: '/images/weekend-getaway.jpg',
                location: 'Mountain Cabin',
                isFavorited: false,
                tags: ['weekend', 'nature', 'relaxation']
            },
            {
                id: '4',
                title: 'Graduation Ceremony',
                date: '2023-06-10',
                imageUrl: '/images/graduation.jpg',
                location: 'University',
                isFavorited: true,
                tags: ['graduation', 'achievement', 'milestone']
            },
            {
                id: '5',
                title: 'Summer BBQ',
                date: '2023-08-05',
                imageUrl: '/images/summer-bbq.jpg',
                location: 'Backyard',
                isFavorited: true,
                tags: ['bbq', 'friends', 'summer']
            }
        ];
    }

    /**
     * Apply current filters to memories
     */
    private applyFilters(): void {
        let filtered = [...this.memories];

        // Apply search filter
        if (this.filters.searchTerm) {
            filtered = filtered.filter(memory =>
                memory.title.toLowerCase().includes(this.filters.searchTerm) ||
                memory.location?.toLowerCase().includes(this.filters.searchTerm) ||
                memory.tags?.some(tag => tag.toLowerCase().includes(this.filters.searchTerm))
            );
        }

        // Apply date filter
        if (this.filters.date !== 'all') {
            filtered = this.sortByDate(filtered, this.filters.date);
        }

        // Apply location filter
        if (this.filters.location !== 'all') {
            filtered = this.filterByLocation(filtered, this.filters.location);
        }

        this.filteredMemories = filtered;
        this.renderMemories();
    }

    /**
     * Sort memories by date
     */
    private sortByDate(memories: Memory[], sortType: FilterOptions['date']): Memory[] {
        const sorted = [...memories];

        switch (sortType) {
            case 'recent':
                return sorted.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
            case 'oldest':
                return sorted.sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime());
            case 'year':
                const currentYear = new Date().getFullYear();
                return sorted.filter(memory => new Date(memory.date).getFullYear() === currentYear);
            default:
                return sorted;
        }
    }

    /**
     * Filter memories by location
     */
    private filterByLocation(memories: Memory[], locationType: FilterOptions['location']): Memory[] {
        // This is a simplified example - in real app, you'd have more sophisticated location logic
        switch (locationType) {
            case 'local':
                return memories.filter(memory =>
                    memory.location?.toLowerCase().includes('home') ||
                    memory.location?.toLowerCase().includes('backyard')
                );
            case 'travel':
                return memories.filter(memory =>
                    !memory.location?.toLowerCase().includes('home') &&
                    !memory.location?.toLowerCase().includes('backyard')
                );
            default:
                return memories;
        }
    }

    /**
     * Render memories to the grid
     */
    private renderMemories(): void {
        const grid = document.querySelector('.memory-grid');
        if (!grid) return;

        // Clear existing cards (keep template)
        const existingCards = grid.querySelectorAll('.memory-card[data-memory-id]');
        existingCards.forEach(card => card.remove());

        // Render filtered memories
        this.filteredMemories.forEach((memory, index) => {
            const card = this.createMemoryCard(memory);
            card.style.animationDelay = `${index * 0.1}s`;
            card.classList.add('fade-in');
            grid.appendChild(card);
        });

        // Show empty state if no memories
        if (this.filteredMemories.length === 0) {
            this.showEmptyState(grid);
        }
    }

    /**
     * Create memory card element
     */
    private createMemoryCard(memory: Memory): HTMLElement {
        const card = document.createElement('div');
        card.className = 'memory-card';
        card.setAttribute('data-memory-id', memory.id);

        card.innerHTML = `
            <div class="memory-card__image">
                <img src="${memory.imageUrl}" alt="${memory.title}" loading="lazy">
                <button class="memory-card__favorite" data-favorited="${memory.isFavorited}">
                    <svg width="18" height="18" viewBox="0 0 24 24" ${memory.isFavorited ? 'fill="currentColor"' : 'fill="none" stroke="currentColor"'}>
                        <path d="M20.84 4.61C20.3292 4.099 19.7228 3.69364 19.0554 3.41708C18.3879 3.14052 17.6725 2.99817 16.95 2.99817C16.2275 2.99817 15.5121 3.14052 14.8446 3.41708C14.1772 3.69364 13.5708 4.099 13.06 4.61L12 5.67L10.94 4.61C9.9083 3.5783 8.50903 2.9987 7.05 2.9987C5.59096 2.9987 4.19169 3.5783 3.16 4.61C2.1283 5.6417 1.5487 7.04097 1.5487 8.5C1.5487 9.95903 2.1283 11.3583 3.16 12.39L12 21.23L20.84 12.39C21.351 11.8792 21.7563 11.2728 22.0329 10.6053C22.3095 9.93789 22.4518 9.22248 22.4518 8.5C22.4518 7.77752 22.3095 7.06211 22.0329 6.39465C21.7563 5.7272 21.351 5.1208 20.84 4.61V4.61Z" ${memory.isFavorited ? '' : 'stroke-width="2" stroke-linecap="round" stroke-linejoin="round"'}/>
                    </svg>
                </button>
            </div>
            <div class="memory-card__content">
                <h3 class="memory-card__title">${memory.title}</h3>
                <p class="memory-card__date">${this.formatDate(memory.date)}</p>
            </div>
        `;

        return card;
    }

    /**
     * Format date for display
     */
    private formatDate(dateString: string): string {
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    }

    /**
     * Show empty state
     */
    private showEmptyState(container: Element): void {
        const emptyState = document.createElement('div');
        emptyState.className = 'empty-state';
        emptyState.innerHTML = `
            <div style="text-align: center; padding: 3rem; color: var(--color-text-muted);">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" style="margin-bottom: 1rem; opacity: 0.5;">
                    <path d="M21 19V5C21 3.89543 20.1046 3 19 3H5C3.89543 3 3 3.89543 3 5V19C3 20.1046 3.89543 21 5 21H19C20.1046 21 21 20.1046 21 19Z" stroke="currentColor" stroke-width="2"/>
                    <path d="M3 7H21" stroke="currentColor" stroke-width="2"/>
                    <path d="M8 11H16" stroke="currentColor" stroke-width="2"/>
                    <path d="M8 15H12" stroke="currentColor" stroke-width="2"/>
                </svg>
                <h3 style="margin-bottom: 0.5rem;">No memories found</h3>
                <p>Try adjusting your search or filter criteria.</p>
            </div>
        `;
        container.appendChild(emptyState);
    }

    /**
     * Set loading state
     */
    private setLoadingState(loading: boolean): void {
        this.isLoading = loading;
        const grid = document.querySelector('.memory-grid');

        if (grid) {
            if (loading) {
                grid.classList.add('memory-grid--loading');
            } else {
                grid.classList.remove('memory-grid--loading');
            }
        }
    }

    /**
     * Show error message
     */
    private showError(message: string): void {
        // Implementation would show error toast/notification
        console.error(message);
    }

    /**
     * Update favorites list in sidebar
     */
    private updateFavoritesList(): void {
        const favoritesList = document.querySelector('.favourite-list');
        if (!favoritesList) return;

        const favoriteMemories = this.memories.filter(m => m.isFavorited);

        // Clear existing items
        favoritesList.innerHTML = '';

        // Add favorite memories
        favoriteMemories.forEach(memory => {
            const item = document.createElement('div');
            item.className = 'favourite-item';
            item.innerHTML = `
                <div class="favourite-item__icon">
                    <img src="${memory.imageUrl}" alt="${memory.title}">
                </div>
                <span class="favourite-item__text">${memory.title}</span>
            `;
            favoritesList.appendChild(item);
        });
    }

    /**
     * Save favorite status to server
     */
    private async saveFavoriteStatus(memoryId: string, isFavorited: boolean): Promise<void> {
        try {
            // Simulate API call
            await fetch(`/api/memories/${memoryId}/favorite`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ isFavorited })
            });
        } catch (error) {
            console.error('Error saving favorite status:', error);
            // Revert the change on error
            const memory = this.memories.find(m => m.id === memoryId);
            if (memory) {
                memory.isFavorited = !isFavorited;
            }
        }
    }

    /**
     * Update storage information
     */
    private updateStorageInfo(): void {
        const storageInfo: StorageInfo = {
            used: 150,
            total: 200,
            percentage: 75
        };

        const progressBar = document.querySelector('.progress-bar__fill') as HTMLElement;
        const usedText = document.querySelector('.storage-info__text') as HTMLElement;
        const detailsText = document.querySelector('.storage-info__details') as HTMLElement;

        if (progressBar) {
            progressBar.style.width = `${storageInfo.percentage}%`;
        }

        if (usedText) {
            usedText.textContent = `${storageInfo.percentage}% used`;
        }

        if (detailsText) {
            detailsText.textContent = `${storageInfo.used} GB of ${storageInfo.total} GB`;
        }
    }
}

// Initialize the page when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new MemoriesPage();
});

// Export for potential use in other modules
export { MemoriesPage, Memory, FilterOptions, StorageInfo };