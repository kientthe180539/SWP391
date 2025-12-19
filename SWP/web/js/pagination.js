// Pagination utility for client-side pagination
function paginateTable(tableId, itemsPerPage = 10, paginationId = 'pagination') {
    const table = document.querySelector(tableId + ' tbody');
    if (!table) return;

    const rows = Array.from(table.querySelectorAll('tr'));
    const totalItems = rows.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);
    let currentPage = 1;

    function showPage(page) {
        currentPage = page;
        const start = (page - 1) * itemsPerPage;
        const end = start + itemsPerPage;

        rows.forEach((row, index) => {
            if (index >= start && index < end) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });

        renderPagination();
    }

    function renderPagination() {
        const container = document.getElementById(paginationId);
        if (!container || totalPages <= 1) {
            if (container) container.style.display = 'none';
            return;
        }

        container.style.display = 'flex';
        container.innerHTML = '';

        // Previous button
        if (currentPage > 1) {
            const prev = document.createElement('a');
            prev.href = '#';
            prev.textContent = '« Trước';
            prev.onclick = (e) => {
                e.preventDefault();
                showPage(currentPage - 1);
            };
            container.appendChild(prev);
        }

        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
            if (i <= 3 || i > totalPages - 3 || (i >= currentPage - 1 && i <= currentPage + 1)) {
                const pageLink = document.createElement('a');
                pageLink.href = '#';
                pageLink.textContent = i;
                pageLink.className = i === currentPage ? 'active' : '';
                pageLink.onclick = (e) => {
                    e.preventDefault();
                    showPage(i);
                };
                container.appendChild(pageLink);
            } else if (i === 3 && currentPage > 5) {
                const ellipsis = document.createElement('span');
                ellipsis.textContent = '...';
                container.appendChild(ellipsis);
            } else if (i === currentPage + 2 && currentPage < totalPages - 4) {
                const ellipsis = document.createElement('span');
                ellipsis.textContent = '...';
                container.appendChild(ellipsis);
            }
        }

        // Next button
        if (currentPage < totalPages) {
            const next = document.createElement('a');
            next.href = '#';
            next.textContent = 'Sau »';
            next.onclick = (e) => {
                e.preventDefault();
                showPage(currentPage + 1);
            };
            container.appendChild(next);
        }
    }

    // Initialize
    showPage(1);
}

// Grid pagination for room cards
function paginateGrid(gridSelector, itemsPerPage = 12, paginationId = 'pagination') {
    const gridContainer = document.querySelector(gridSelector);
    if (!gridContainer) return;

    const items = Array.from(gridContainer.children);
    const totalItems = items.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);
    let currentPage = 1;

    function showPage(page) {
        currentPage = page;
        const start = (page - 1) * itemsPerPage;
        const end = start + itemsPerPage;

        items.forEach((item, index) => {
            if (index >= start && index < end) {
                item.style.display = '';
            } else {
                item.style.display = 'none';
            }
        });

        renderPagination();
    }

    function renderPagination() {
        const container = document.getElementById(paginationId);
        if (!container || totalPages <= 1) {
            if (container) container.style.display = 'none';
            return;
        }

        container.style.display = 'flex';
        container.innerHTML = '';

        // Previous button
        if (currentPage > 1) {
            const prev = document.createElement('a');
            prev.href = '#';
            prev.textContent = '« Trước';
            prev.onclick = (e) => {
                e.preventDefault();
                showPage(currentPage - 1);
            };
            container.appendChild(prev);
        }

        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
            if (i <= 3 || i > totalPages - 3 || (i >= currentPage - 1 && i <= currentPage + 1)) {
                const pageLink = document.createElement('a');
                pageLink.href = '#';
                pageLink.textContent = i;
                pageLink.className = i === currentPage ? 'active' : '';
                pageLink.onclick = (e) => {
                    e.preventDefault();
                    showPage(i);
                };
                container.appendChild(pageLink);
            } else if (i === 3 && currentPage > 5) {
                const ellipsis = document.createElement('span');
                ellipsis.textContent = '...';
                container.appendChild(ellipsis);
            } else if (i === currentPage + 2 && currentPage < totalPages - 4) {
                const ellipsis = document.createElement('span');
                ellipsis.textContent = '...';
                container.appendChild(ellipsis);
            }
        }

        // Next button
        if (currentPage < totalPages) {
            const next = document.createElement('a');
            next.href = '#';
            next.textContent = 'Sau »';
            next.onclick = (e) => {
                e.preventDefault();
                showPage(currentPage + 1);
            };
            container.appendChild(next);
        }
    }

    // Initialize
    showPage(1);
}
