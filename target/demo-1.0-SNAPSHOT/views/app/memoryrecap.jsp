function loadStory() {
if (!currentRecap) return;

const memories = currentRecap.memories;

// Create progress bars - ESCAPED ${ for JSP
        document.getElementById('progressBars').innerHTML = memories.map((_, i) => `
                <div class="progress-bar \${i < currentIndex ? 'completed' : ''} \${i === currentIndex ? 'active' : ''}">
                <div class="progress-fill"></div>
                </div>
                `).join('');

                // Create story slides - ESCAPED ${ for JSP
                document.getElementById('storyContent').innerHTML = memories.map((memory, i) => `
                <div class="story-slide \${i === currentIndex ? 'active' : ''}">
                        <img src="\${memory.image}" alt="\${memory.title}" class="story-image">
                <div class="story-caption">
        <div class="caption-title">\${memory.title}</div>
        <div class="caption-text">\${memory.caption}</div>
        </div>
        </div>
                `).join('');

        startProgress();
        }