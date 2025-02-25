NAME = minitalk
SRCS = client.c server.c
CC = cc
CFLAGS = -Wall -Wextra -Werror -g
PRINTF_PATH = ./ft_printf
LIBFT_PATH = ./libft
PRINTF = $(PRINTF_PATH)/libftprintf.a
LIBFT = $(LIBFT_PATH)/libft.a
OBJS = $(SRCS:.c=.o)

all: $(PRINTF) $(LIBFT) $(NAME)

$(NAME): $(LIBFT) $(OBJS) $(PRINTF)
	$(CC) $(CFLAGS) -g $(LIBFT) $(OBJS) $(PRINTF) -o $(NAME)

$(LIBFT):
	@echo "Checking libft repository..."
	@if [ ! -d "$(LIBFT_PATH)" ]; then \
		echo "Cloning libft repository..."; \
		git clone git@github.com:ilyasguney/libft.git $(LIBFT_PATH); \
	else \
		echo "libft repository already exists, skipping clone."; \
	fi
	@echo "Building libft library..."

$(PRINTF):
	@echo "Checking printf repository..."
	@if [ ! -d "$(PRINTF_PATH)" ]; then \
		echo "Cloning printf repository..."; \
		git clone https://github.com/ilyasguney/printf.git $(PRINTF_PATH); \
	else \
		echo "printf repository already exists, skipping clone."; \
	fi
	@echo "Building printf library..."
	@make -C $(PRINTF_PATH)

clean:
	@rm -f $(OBJS) $(PRINTF)
	@make clean -C $(PRINTF_PATH)

fclean: clean
	@rm -rf $(NAME) $(PRINTF)
	@make fclean -C $(PRINTF_PATH)
	@rm -rf ft_printf
	@rm -rf libft
	@rm -rf mlx 

re: fclean all

.PHONY: all clean re fclean clear