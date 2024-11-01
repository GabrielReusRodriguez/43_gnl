# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: greus-ro <greus-ro@student.42barcel>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/13 02:39:39 by greus-ro          #+#    #+#              #
#    Updated: 2024/11/01 23:06:01 by greus-ro         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

################################################################################
# Colours
################################################################################

RST				= \033[0;39m
GRAY			= \033[0;90m
RED				= \033[0;91m
GREEN			= \033[0;92m
YELLOW			= \033[0;93m
BLUE			= \033[0;94m
MAGENTA			= \033[0;95m
CYAN			= \033[0;96m
WHITE			= \033[0;97m

################################################################################
# Folders
################################################################################

INC_DIR=./include
OBJ_DIR=./build
BIN_DIR=./bin
SRC_DIR=./src
LIBFT_DIR = ./libft
LIBFT_LIB = ${LIBFT_DIR}/bin/libft.a

################################################################################
# Compiler stuff
################################################################################

NAME		= libgnl.a
CC			= cc
CFLAGS		= -Wall -Werror -Wextra -MMD -MP
DFLAGS		= -D BUFFER_SIZE=30

ifdef	CSANITIZE
	SANITIZE_FLAGS	= -g3 -fsanitize=address -fsanitize=leak
endif

SRC		= 	ft_get_next_line.c 				\
			ft_get_next_line_bonus.c
			
HDR		=	ft_get_next_line.h

LIBFT_SRC = ${LIBFT_DIR}/src/ft_strjoin.c	\
			${LIBFT_DIR}/src/ft_strlen.c	\
			${LIBFT_DIR}/src/ft_istrchr.c	\
			${LIBFT_DIR}/src/ft_substr.c 	\
			${LIBFT_DIR}/src/ft_pointer.c	\
			${LIBFT_DIR}/src/ft_calloc.c	\
			${LIBFT_DIR}/src/ft_strlcpy.c	\
			${LIBFT_DIR}/src/ft_strlcat.c	\
			${LIBFT_DIR}/src/ft_bzero.c		\
			${LIBFT_DIR}/src/ft_memset.c	\

LIBFT_HDR = ${LIBFT_DIR}/include/libft.h

GNL_LIBFT_SRC = $(patsubst ${LIBFT_DIR}/src/%.c, ${SRC_DIR}/import/%.c, ${LIBFT_SRC})
GNL_LIBFT_HDR = $(patsubst ${LIBFT_DIR}/include/%.h, ${INC_DIR}/import/%.h, ${LIBFT_HDR})

SRCS	= $(patsubst %.c, ${SRC_DIR}/%.c, ${SRC}) ${GNL_LIBFT_SRC}
HDRS	= $(patsubst %.h, ${INC_DIR}/%.h, ${HDR}) ${GNL_LIBFT_HDR}
OBJS	= $(patsubst %.c, ${OBJ_DIR}/%.o, ${SRC}) $(patsubst ${SRC_DIR}/import/%.c, ${OBJ_DIR}/import/%.o, ${GNL_LIBFT_SRC})
DEPS	= $(patsubst %.c, ${OBJ_DIR}/%.d, ${SRC}) $(patsubst ${SRC_DIR}/import/%.c, ${OBJ_DIR}/import/%.d, ${GNL_LIBFT_SRC})

#SRCS	= $(patsubst %.c, ${SRC_DIR}/%.c, ${SRC} ${GNL_LIBFT_SRC}) 
#HDRS	= $(patsubst %.h, ${INC_DIR}/%.h, ${HDR} ${GNL_LIBFT_HDR}) 
#OBJS	= $(patsubst %.c, ${OBJ_DIR}/%.o, ${SRC} ${GNL_LIBFT_SRC})
#DEPS	= $(patsubst %.c, ${OBJ_DIR}/%.d, ${SRC} ${GNL_LIBFT_SRC})

all: folders ${SRCS} ${HDRS} ${BIN_DIR}/${NAME}

${SRCS}:
	git submodule update --init
	cp ${LIBFT_DIR}/src/ft_strjoin.c ${SRC_DIR}/import/ft_strjoin.c
	cp ${LIBFT_DIR}/src/ft_strlen.c ${SRC_DIR}/import/ft_strlen.c
	cp ${LIBFT_DIR}/src/ft_istrchr.c ${SRC_DIR}/import/ft_istrchr.c
	cp ${LIBFT_DIR}/src/ft_substr.c ${SRC_DIR}/import/ft_substr.c
	cp ${LIBFT_DIR}/src/ft_pointer.c ${SRC_DIR}/import/ft_pointer.c
	cp ${LIBFT_DIR}/src/ft_calloc.c ${SRC_DIR}/import/ft_calloc.c
	cp ${LIBFT_DIR}/src/ft_strlcpy.c ${SRC_DIR}/import/ft_strlcpy.c
	cp ${LIBFT_DIR}/src/ft_strlcat.c ${SRC_DIR}/import/ft_strlcat.c
	cp ${LIBFT_DIR}/src/ft_bzero.c ${SRC_DIR}/import/ft_bzero.c
	cp ${LIBFT_DIR}/src/ft_memset.c ${SRC_DIR}/import/ft_memset.c
	
${HDRS}:
	git submodule update --init
	cp ${LIBFT_DIR}/include/libft.h ${INC_DIR}/import/libft.h

${BIN_DIR}/${NAME}: ${OBJS} Makefile
	@echo "\t${CYAN}Linking ${NAME}${RST}"
	ar -rcs ${BIN_DIR}/${NAME} ${OBJS}

${OBJ_DIR}/%.o:${SRC_DIR}/%.c Makefile
	@echo "\t${YELLOW}Compiling ${RST} $<"
	@${CC} ${CFLAGS} ${SANITIZE_FLAGS} ${DFLAGS} -I ${INC_DIR} -I ${INC_DIR}/import -o $@ -c $<

clean:
	rm -rf ${OBJ_DIR}

fclean: clean 
	rm -rf ${BIN_DIR}

re: fclean all

folders: 
	@mkdir -p ${BIN_DIR}
	@mkdir -p ${OBJ_DIR}
	@mkdir -p ${OBJ_DIR}/import
	@mkdir -p ${SRC_DIR}/import
	@mkdir -p ${INC_DIR}/import
	
-include ${DEPS}

.PHONY: all clean fclean re folders