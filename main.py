import sys
import os

def setup_environment():
    if 'raspberrypi' in os.uname().nodename.lower():
        # set any environment variables needed for pygame to work
        pass

def main():
    pygame.init()

    # Screen dimensions
    screen_width = 1280
    screen_height = 800
    screen = pygame.display.set_mode((screen_width, screen_height))
    pygame.display.set_caption("Pygame Hello World")

    # Colors
    white = (255, 255, 255)
    black = (0, 0, 0)

    # Font
    font = pygame.font.Font(None, 74)
    text_surface = font.render("Hello, World!", True, black)
    text_rect = text_surface.get_rect(center=(screen_width // 2, screen_height // 2))

    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    running = False

        screen.fill(white)
        screen.blit(text_surface, text_rect)
        pygame.display.flip()

    pygame.quit()
    sys.exit()

if __name__ == "__main__":
    setup_environment()
    import pygame
    main()
